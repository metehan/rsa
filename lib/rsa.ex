defmodule RSA do
  def decrypt_priv(text, key, b64 \\ false) do
    text = if b64, do: :base64.decode(text) ,else: text
    :public_key.decrypt_private(text,ensure_asn1(key))
  end

  def decrypt_pub(text, key, b64 \\ false) do
    text = if b64, do: :base64.decode(text) ,else: text
    :public_key.decrypt_public(text,ensure_asn1(key))
  end

  def encrypt_priv(text, key, b64 \\ false) do
    r = :public_key.encrypt_private(text,ensure_asn1(key))
    if b64, do: :base64.encode_to_string(r) ,else: r
  end

  def encrypt_pub(text, key, b64 \\ false) do
    r = :public_key.encrypt_public(text,ensure_asn1(key))
    if b64, do: :base64.encode_to_string(r) ,else: r
  end

  def sign(msg, priv, b64 \\ false) do
    r = :public_key.sign(msg, :sha256, ensure_asn1(priv))
    if b64, do: :base64.encode_to_string(r) ,else: r
  end

  def verify(msg, sign, pub, b64 \\ false) do
    sign = if b64, do: :base64.decode(sign) ,else: sign
    :public_key.verify(msg, :sha256, sign, ensure_asn1(pub))
  end

  #CONVERT PEM TO ASN1
  defp ensure_asn1(key) do
    if is_tuple(key) do
      key
    else
      from_pem(key)
    end
  end

  def from_pem(text) do
    [entry] = :public_key.pem_decode(text)
   :public_key.pem_entry_decode(entry)
  end

  def generate_pair(x \\ "2048") do
    #https://github.com/elefthei/krypto
    publicKey = "ExPublicKey.pem"
    privateKey = "ExPrivateKey.pem"
    {_, 0} = System.cmd "openssl", [ "genrsa", "-out", privateKey, x], [stderr_to_stdout: true]
    {_, 0} = System.cmd "openssl", [ "rsa", "-pubout", "-in" , privateKey, "-out", publicKey ], [stderr_to_stdout: true]
    {:ok, priv} = File.read(privateKey)
    {:ok, pub} = File.read(publicKey)

    # Overwrite with random to ensure non-retrieval of keys
    File.copy("/dev/random", privateKey, byte_size(priv))
    File.copy("/dev/random", publicKey, byte_size(pub))
    {_, 0} = System.cmd "rm", ["-f", privateKey]
    {_, 0} = System.cmd "rm", ["-f", publicKey]
    {priv,pub}
  end
end
