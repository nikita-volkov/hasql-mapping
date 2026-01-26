# hasql-mapping

[![Hackage](https://img.shields.io/hackage/v/hasql-mapping.svg)](https://hackage.haskell.org/package/hasql-mapping)
[![Continuous Haddock](https://img.shields.io/badge/haddock-master-blue)](https://nikita-volkov.github.io/hasql-mapping/)

SDK for defining mappings between Haskell and PostgreSQL.

The central piece of this library is the `IsStatement` typeclass, which is used for declaring type-safe mappings to particular SQL statements.
