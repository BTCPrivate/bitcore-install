# bitcore-install - v0.0.1

### Vendor backend samples for BTCP (Javascript, Bitcore)

Run any one of these in a fresh Ubuntu VM to get started:

#### `btcp_store_demo.sh`
- Creates a bitcore fullnode configured for `store-demo`, as well as block explorer + api
- **Public AMI:** BTCP-Store (ami-62e3881a)

#### `btcp_explorer_demo.sh`
- Creates a bitcore fullnode configured for block explorer + api (`insight-ui-btcp` and `insight-api-btcp`)

#### `btcp_fetch_wallet.sh`
- Acquires `btcpd` and `btcp-cli` by either downloading the [latest indexing-enabled binaries](https://github.com/BTCPrivate/BitcoinPrivate/releases/tag/v1.0.11-d3905b0), or by fetching the [source on the explorer-btcp branch](https://github.com/BTCPrivate/BitcoinPrivate/tree/explorer-btcp) and building


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

Runs with bitcore-node-btcp (fork of bitcore-node v4) on bitcore v3.1. Original work: [str4d/insight-api-zcash](https://github.com/str4d/insight-api-zcash).

