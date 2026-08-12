# v0.1.1.0

- Added `Hasql.Mapping.IsTransaction` and `Hasql.Mapping.IsSession`, completing the class family alongside `IsScalar` and `IsStatement`.
- Added `IsStatement.toSession`, `IsStatement.toPipeline`, `IsStatement.toTransaction`, `IsTransaction.toSessionWithUnboundedRetries` and `IsTransaction.toSessionWithoutRetries` runners.
- New dependency: `hasql-transaction ^>=1.2.3`.

# v0.1.0.2

- Added support for Hasql 2.0.
