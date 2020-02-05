package main

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"
)

var requiredEnvs = []string{"VAULT_ADDR", "VAULT_ROLE"}

var defaultEnvs = map[string]string{
	"KUBERNETES_TOKEN_PATH": "/var/run/secrets/kubernetes.io/serviceaccount/token",
	"ONLY_RUN_ONCE":         "false",
	"SECRETS_DIRECTORY":     "/secrets",
}

type VaultLoginRequest struct {
	Role string `json:"role"`
	JWT  string `json:"jwt"`
}

type VaultLoginResponse struct {
	Auth struct {
		ClientToken string `json:"client_token"`
	} `json:"auth"`
}

func preFlight() bool {
	log.Printf("performing pre-flight check")
	ok := true

	log.Printf("validating required environment variables...")
	for _, envVar := range requiredEnvs {
		if envVal := os.Getenv(envVar); envVal != "" {
			log.Printf("%s=%s", envVar, envVal)
		} else {
			log.Printf("%s=? (NOT SET)", envVar)
			ok = false
		}
	}

	log.Printf("populating default environment variables...")
	for k, v := range defaultEnvs {
		if override := os.Getenv(k); override != "" {
			os.Setenv(k, override)
			log.Printf("%s=%s (OVERRIDE)", k, os.Getenv(k))
		} else {
			os.Setenv(k, v)
			log.Printf("%s=%s", k, os.Getenv(k))
		}
	}

	log.Printf("checking paths...")
	if _, err := os.Stat(os.Getenv("SECRETS_DIRECTORY")); os.IsNotExist(err) {
		log.Printf("SECRETS_DIRECTORY=%s (NONEXISTENT)", os.Getenv("SECRETS_DIRECTORY"))
		ok = false
	} else {
		log.Printf("SECRETS_DIRECTORY=%s", os.Getenv("SECRETS_DIRECTORY"))
	}

	if _, err := os.Stat(os.Getenv("KUBERNETES_TOKEN_PATH")); os.IsNotExist(err) {
		log.Printf("KUBERNETES_TOKEN_PATH=%s (NONEXISTENT)", os.Getenv("KUBERNETES_TOKEN_PATH"))
		ok = false
	} else {
		log.Printf("KUBERNETES_TOKEN_PATH=%s", os.Getenv("KUBERNETES_TOKEN_PATH"))
	}

	return ok
}

func writeToken() bool {
	log.Printf("logging into vault")
	log.Printf("reading token from %s", os.Getenv("KUBERNETES_TOKEN_PATH"))
	content, err := ioutil.ReadFile(os.Getenv("KUBERNETES_TOKEN_PATH"))
	if err != nil {
		log.Printf("error reading token: ", err)
		return false
	}

	log.Printf("constructing payload for logging into vault")
	payload, err := json.Marshal(VaultLoginRequest{
		JWT:  strings.TrimSpace(string(content)),
		Role: os.Getenv("VAULT_ROLE"),
	})
	if err != nil {
		log.Printf("could not serialize payload: %s", err)
		return false
	}

	url := os.Getenv("VAULT_ADDR") + "/v1/auth/kubernetes/login"
	log.Printf("sending payload to %s", url)
	resp, err := http.Post(url, "application/json", bytes.NewBuffer(payload))
	if err != nil {
		log.Printf("could not log in, vault returned an error: %s", err)
		return false
	}
	defer resp.Body.Close()

	log.Printf("server returned %d, reading response", resp.StatusCode)
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Printf("could not read response body: %s", err)
		return false
	}

	log.Printf("parsing response body into JSON")
	response := VaultLoginResponse{}
	if err = json.Unmarshal(body, &response); err != nil {
		log.Printf("could not read parse body into JSON: %s", err)
		return false
	}

	vault_token_dst := filepath.Join(os.Getenv("SECRETS_DIRECTORY"), "token")
	log.Printf("writing vault token to %s", vault_token_dst)
	target, err := os.OpenFile(vault_token_dst, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0666)
	if err != nil {
		log.Printf("error creating %s: %s", vault_token_dst, err)
	}
	_, err = target.WriteString(response.Auth.ClientToken)
	if err != nil {
		log.Printf("error writing token to %s: %s", vault_token_dst, err)
		return false
	}

	err = target.Close()
	if err != nil {
		log.Printf("error closing new file at %s: %s", vault_token_dst, err)
		return false
	}

	return true
}

func writeSecrets() bool {
	ok := true

	vaultTokenPath := filepath.Join(os.Getenv("SECRETS_DIRECTORY"), "token")
	log.Printf("reading vault token from %s", vaultTokenPath)
	content, err := ioutil.ReadFile(vaultTokenPath)
	if err != nil {
		log.Printf("error reading token: ", err)
		return false
	}
	vaultToken := strings.TrimSpace(string(content))

	for _, e := range os.Environ() {
		pair := strings.SplitN(e, "=", 2)
		key, val := pair[0], pair[1]

		if !strings.HasPrefix(key, "SECRET_") {
			continue
		}

		log.Printf("processing %s=%s", key, val)
		fileTarget := filepath.Join(os.Getenv("SECRETS_DIRECTORY"), strings.Replace(key, "SECRET_", "", 1))
		url := os.Getenv("VAULT_ADDR") + "/v1/secret/data" + val
		client := &http.Client{}
		req, err := http.NewRequest("GET", url, nil)
		if err != nil {
			log.Printf("error creating GET request for %s: %s", url, err)
			return false
		}
		req.Header.Add("X-Vault-Token", vaultToken)
		log.Printf("sending request to %s", url)
		resp, err := client.Do(req)
		if err != nil {
			log.Printf("vault returned an error from %s: %s", url, err)
			return false
		}
		log.Printf("server returned %d, reading response", resp.StatusCode)
		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			log.Printf("could not read response body: %s", err)
			return false
		}
		defer resp.Body.Close()
		log.Printf("parsing response body into JSON")

		log.Printf("writing response to %s", fileTarget)
		target, err := os.OpenFile(fileTarget, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0666)
		if err != nil {
			log.Printf("error creating %s: %s", fileTarget, err)
			return false
		}
		_, err = target.WriteString(string(body))
		if err != nil {
			log.Printf("error writing token to %s: %s", fileTarget, err)
			return false
		}

		err = target.Close()
		if err != nil {
			log.Printf("error closing new file at %s: %s", fileTarget, err)
			return false
		}

	}

	return ok
}

func main() {
	log.Printf("starting secretboi")

	for {
		if !preFlight() {
			log.Fatal("pre-flight check failed, exiting!")
		}

		if !writeToken() {
			log.Fatal("failed to get vault token, exiting!")
		}

		if !writeSecrets() {
			log.Fatal("failed to write secrets, exiting!")
		}

		if os.Getenv("ONLY_RUN_ONCE") != "false" {
			log.Printf("since ONLY_RUN_ONCE enabled, exiting")
			break
		}

		time.Sleep(300 * time.Second)
	}
}
