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
)

var requiredEnvs = []string{"VAULT_ADDR", "VAULT_ROLE"}

var defaultEnvs = map[string]string{
	"KUBERNETES_TOKEN_PATH": "/var/run/secrets/kubernetes.io/serviceaccount/token",
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

func vaultLogin() bool {
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
	target, err := os.Create(vault_token_dst)
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

func main() {
	log.Printf("starting secretboi")

	if !preFlight() {
		log.Fatal("pre-flight check failed, exiting!")
	}

	if !vaultLogin() {
		log.Fatal("vault login failed, exiting!")
	}
}
