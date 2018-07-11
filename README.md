# bitcore-install - v0.0.3

### Vendor backend samples for BTCP (Javascript, Bitcore)

Run any one of these in a fresh Ubuntu VM to get started:

#### `btcp_store_demo.sh`
- Creates a javascript full-node (bitcore, with the [btcpd](https://github.com/BTCPrivate/BitcoinPrivate/tree/explorer-btcp) daemon), listening on port 8001. By default, includes `insight-api-btcp`.

#### `btcp_explorer_demo.sh`
- Creates a javascript full-node configured for block explorer + api (`insight-ui-btcp` and `insight-api-btcp`)

#### `btcp_daemon_only.sh`
- Acquires `btcpd` and `btcp-cli` by either downloading the [latest indexing-enabled binaries](https://github.com/BTCPrivate/BitcoinPrivate/releases/tag/1.0.12-69aa9ce), or by fetching the [source on the explorer-btcp branch](https://github.com/BTCPrivate/BitcoinPrivate/tree/explorer-btcp) and building


# Related Repos

- [store-demo](https://github.com/BTCPrivate/store-demo)
- [address-watch](https://github.com/BTCPrivate/address-watch)
- [bitcore-node-btcp](https://github.com/BTCPrivate/bitcore-node-btcp)
- [bitcore-lib-btcp](https://github.com/BTCPrivate/bitcore-lib-btcp)
- [bitcore-p2p-btcp](https://github.com/BTCP-community/bitcore-p2p-btcp)
- [bitcore-message-btcp](https://github.com/BTCPrivate/bitcore-message-btcp)
- [bitcore-build-btcp](https://github.com/BTCPrivate/bitcore-build-btcp)
- [insight-ui-btcp](https://github.com/BTCPrivate/insight-ui-btcp)
- [insight-api-btcp](https://github.com/BTCPrivate/insight-api-btcp)

- [Bitcoin Private Daemon + CLI](https://github.com/BTCPrivate/BitcoinPrivate/tree/explorer-btcp)

Runs using bitcore-node-btcp (fork of bitcore-node v4) on bitcore v3.1. Original work: [str4d/insight-api-zcash](https://github.com/str4d/insight-api-zcash).

