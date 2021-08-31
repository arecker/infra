#!/usr/bin/env bats

NAMESERVER="${NAMESERVER:-8.8.8.8}"

@test "reckerfamily.com - mail" {
    actual="$(dig @${NAMESERVER} +short reckerfamily.com. MX | sort)"
    expected="1 aspmx.l.google.com.
10 alt3.aspmx.l.google.com.
10 alt4.aspmx.l.google.com.
5 alt1.aspmx.l.google.com.
5 alt2.aspmx.l.google.com."
    [ "$actual" == "$expected" ]
}

@test "reckerfamily.com - cookbook" {
    actual="$(dig @${NAMESERVER} +short cookbook.reckerfamily.com. CNAME)"
    [ "$actual" == "readthedocs.io." ]
}

@test "alexandmarissa.com - mail" {
    actual="$(dig @${NAMESERVER} +short alexandmarissa.com MX | sort)"
    expected="10 mx1.privateemail.com.
10 mx2.privateemail.com."
    [ "$actual" == "$expected" ]
}

@test "tranquilitydesignsmn.com - mail" {
    actual="$(dig @${NAMESERVER} +short tranquilitydesignsmn.com MX | sort)"
    expected="10 mx1.privateemail.com.
10 mx2.privateemail.com."
    [ "$actual" == "$expected" ]
}

@test "astuaryart.com - CNAME" {
    actual="$(dig @${NAMESERVER} +short www.astuaryart.com CNAME)"
    [ "$actual" == "ext-cust.squarespace.com." ]
}
