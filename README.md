# RSA with openssl

This `:pk_rsa` package uses system command `openssl` to generate key pairs. Your system must have openssl installed and included in the `PATH`. If you don't need to create key pairs with this package you don't need it to encrypt and decrypt. The "pk" in the package name refers to `:public_key` of erlang which we use.

There are other RSA packages but I wanted to embed `base64` option.Make the package simpler and more readable. 

## Usage

To generate key pair with openssl we use `RSA.generate_pair` it will return a tupple containing keys. Keys are formatted as pem file strings.

```
iex(1)> {private_key, public_key} = RSA.generate_pair()
iex(2)> private_key
"-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEA6mz...
iex(3)> public_key
"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgk
```

To encrypt messages we have two functions `RSA.encrypt_priv/3` for encrypting with private key and `RSA.encrypt_pub/3` for encrypting with public key. Third parameter is optional boolean to tell the function we want to use `base64` format.

```
iex(4)> RSA.encrypt_priv("hello", private_key)
<<38, 219, 161, 223, 29, 149, 176, 251, 218, 69, 161, 3, 39, 73, 2, 153, 40, ...>>
iex(5)> RSA.encrypt_priv("hello", private_key, true)
'Jtuh3x2VsPvaRaEDJ0kCmSjPtpZ0jm/KNVr2NM...
```

When you encrypt with `private_key` you need to use `public_key` to decrypt. Same way you can encrypt with `public_key` and decrypt with `private_key` 

You can also sign and verify messages with `RSA.sign/3` and `RSA.verify/4` functions. Last arguement is oprional if true `base64` will be used.

```
iex(6)> signature = RSA.sign("hello", private_key, true)
'HbNqLYt5MxDayLBnv81RKBvqN...
iex(7)> RSA.verify("hello",signature, public_key, true)
true
```



## Installation

The package can be installed by adding `pk_rsa` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pk_rsa, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and can be found at [https://hexdocs.pm/pk_rsa](https://hexdocs.pm/pk_rsa).

## Thanks
Generate pair function is taken from `elefthei/krypto`
