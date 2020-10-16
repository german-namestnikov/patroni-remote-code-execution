# Proof of Concept script for Patroni Remote Code Execution
TL;DR: Patching some PostgreSQL settings values via Patroni HTTP API allows an authenticated (or non-authenticated if there is no auth required) attacker execute OS commands on the cluster members 

Read more: https://illegalbytes.com/2020-10-14/patroni-remote-code-execution/

Discussion with developer: https://github.com/zalando/patroni/issues/1734
