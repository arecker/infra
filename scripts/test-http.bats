#!/usr/bin/env bats

_curl_status() {
    local url="$1"
    curl -s -o /dev/null -w "%{http_code}" "$url"
}

@test "blog" {
    [ "$(_curl_status https://www.alexrecker.com)" == "200" ] &&
        [ "$(_curl_status http://www.alexrecker.com)" == "301" ] &&
        [ "$(_curl_status https://alexrecker.com)" == "301" ] &&
        [ "$(_curl_status http://alexrecker.com)" == "301" ]
}

@test "astuary" {
    [ "$(_curl_status https://www.astuaryart.com)" == "200" ] &&
        [ "$(_curl_status http://www.astuaryart.com)" == "301" ] &&
        [ "$(_curl_status https://astuaryart.com)" == "301" ] &&
        [ "$(_curl_status http://astuaryart.com)" == "301" ]
}

@test "wedding" {
    [ "$(_curl_status https://www.alexandmarissa.com)" == "200" ] &&
        [ "$(_curl_status http://www.alexandmarissa.com)" == "301" ] &&
        [ "$(_curl_status https://alexandmarissa.com)" == "301" ] &&
        [ "$(_curl_status http://alexandmarissa.com)" == "301" ]
}

@test "bob" {
    [ "$(_curl_status https://www.bobrosssearch.com)" == "200" ] &&
        [ "$(_curl_status http://www.bobrosssearch.com)" == "301" ] &&
        [ "$(_curl_status https://bobrosssearch.com)" == "301" ] &&
        [ "$(_curl_status http://bobrosssearch.com)" == "301" ]
}

@test "tranquility" {
    [ "$(_curl_status https://www.tranquilitydesignsmn.com)" == "200" ] &&
        [ "$(_curl_status http://www.tranquilitydesignsmn.com)" == "301" ] &&
        [ "$(_curl_status https://tranquilitydesignsmn.com)" == "301" ] &&
        [ "$(_curl_status http://tranquilitydesignsmn.com)" == "301" ]
}

@test "cookbook" {
    [ "$(_curl_status https://cookbook.reckerfamily.com)" == "200" ] &&
        [ "$(_curl_status http://cookbook.reckerfamily.com)" == "302" ]
}
