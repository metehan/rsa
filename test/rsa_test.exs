defmodule RSATest do
  use ExUnit.Case
  doctest RSA
  @priv "-----BEGIN RSA PRIVATE KEY-----\nMIIEogIBAAKCAQEA18m7LDrrlLkl7UFGny/UAyybRPfnrrPzZ2tQCLihuzOcvFog\ncnUcR0HTuDhiuEIk+uhcrmTSkq8OS7I1r9WUyLPYjteEI21UApc8WmKjardh7Q/A\nA2Dajc1GR8+Qjpv1gBo7Y6cCyIOnjAAAaMfW52SFdjmh0nrx8Doj2eQMlcrlBPzt\nMc0XoTWT6jz7Kh2ju1MU0TO8adoGVwVv5X4PqW0sMbCbQ67iWTOCYv6RTVvERgDT\nkeSN8KmRsO/tIA8FjPxM1syOHAOTpxgh9rSQjzQ5R5TvE/Tv4siwLBj572du+3GC\nMblhWZ6XnN/7pfjZtEQI4h8GjxM4iAICZWMaUwIDAQABAoIBAGcP5YKhfYThzRh8\n9cLv7/24H0yYbqJFNjqtyWLw8+XaJ8DZ9udTwbbS3ND+tT+1772anzF33A7M5zIG\nIpghlVcqdoL6shTNkbNPEjdFJzG/9lhoDlhOuPPDGA8SNsO1/1I4tSbKTI0CPFKk\naY2h7KVFoGyv5/cEW2tWCWt2/P/JMAhrjB9sAyzvvjfx9AJ938ylkOwN1MzrZcNp\n5jEy6MFbdcvRuFKTQGin8aORC16PCeR4y1cVyS9kGfxBcyi+pgsPtQ1OlIX8XvM3\n5sP5+n0dxdqnm8wOUqsv6/ElXYed44WAbOEFZcWQZjwyQpIOBYGzzC08tLIvppkz\noLxU3MECgYEA+zIUOtxdnu46y9aOd1H5dV8xxNOAxcyjhRWtq8rMj7RleDozMVQ6\n1wNfa77SPBSkWVFFiNrvmxKB8THqRz3Mvy4mjTYswXay2TpCpDtONJ2InOtUXMMi\nxWyZq7XCMLTHxDWevDpmdATghcucgasfGFcuTzJNa2gGvxtdLz3jXrMCgYEA2+pJ\neF0bHKpJT8vGCYVPE2P+uGUFomRzkb61PjojsuARAlDi81vdZMUDrXfEA8PyTv9G\nxapT9TjHtGI84hoFw0TeqY+yib94ttRzVMILAgsi9DQqNRkhrDyAwxLJMyrPmd1B\nb39sMU/yyFwun3GXdF891Z3Z6ob5KpEo4LsvJeECgYAwMNpatH4tiGy1QHNShuKB\n1wJ4TU9OI0VXueH4rE50X1p8J0Y893jWWSpMRG6W4irpi8L4T3BaYsGVIUtd4YhP\nQS5aNwN9FiWXsSqp0Ureoz5bRHaJ2VHpaD1PCO65Y2VTyimq2NVg+rKMWJSs98Re\nahNTVEYwDeQFc917u7bMKwKBgDAt9gaurz/qdsFKrYpscFSZNbcEOuXHCCLIG0EU\nz7liqZdOTUpvt+NZ3mJkuMbyaOWxu7mWhWpWFDqKwzft55FOR1Hyr3TKRBIaHWJW\nWL8L3Y6O1yhm5x+q6bLTLM1O9ciJ1sosqnFrSI9o0rYP1tSiARQJzzI4e+I9hy0l\nFUFBAoGAAhQbEORczN61yhdCPCkggOYTpFFUFTqQaQ+bq9CI/spKsH89ASe4ABqD\n2kHyqiPXkWSHzvaKM/W3UQBBOvHix25LIjv7w6lROGHGz4Ez6W/FUNhLutTYCT6q\n+tlNMv4ZfHHwewq67vK5ktsA2UmsSNN7wbU+Z7RRbUGAEuZRWnk=\n-----END RSA PRIVATE KEY-----\n"
  @pub "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA18m7LDrrlLkl7UFGny/U\nAyybRPfnrrPzZ2tQCLihuzOcvFogcnUcR0HTuDhiuEIk+uhcrmTSkq8OS7I1r9WU\nyLPYjteEI21UApc8WmKjardh7Q/AA2Dajc1GR8+Qjpv1gBo7Y6cCyIOnjAAAaMfW\n52SFdjmh0nrx8Doj2eQMlcrlBPztMc0XoTWT6jz7Kh2ju1MU0TO8adoGVwVv5X4P\nqW0sMbCbQ67iWTOCYv6RTVvERgDTkeSN8KmRsO/tIA8FjPxM1syOHAOTpxgh9rSQ\njzQ5R5TvE/Tv4siwLBj572du+3GCMblhWZ6XnN/7pfjZtEQI4h8GjxM4iAICZWMa\nUwIDAQAB\n-----END PUBLIC KEY-----\n"

  test "generate key pair with openssl" do
    assert {private, public} = RSA.generate_pair()
    assert Regex.match?(~r/PRIVATE/, private)
    assert Regex.match?(~r/PUBLIC/, public)
  end

  test "encrypt with private and decrypt with public key" do
    encrypted = RSA.encrypt_priv("hello", @priv)
    assert is_bitstring(encrypted)

    assert "hello" == RSA.decrypt_pub(encrypted, @pub)
  end

  test "encrypt with private and decrypt with public key base64" do
    encrypted = RSA.encrypt_priv("hello", @priv, true)
    assert is_list(encrypted)

    assert "hello" == RSA.decrypt_pub(encrypted, @pub, true)
  end

  test "encrypt with public and decrypt with private key" do
    encrypted = RSA.encrypt_pub("hello", @pub)
    assert is_bitstring(encrypted)

    assert "hello" == RSA.decrypt_priv(encrypted, @priv)
  end

  test "encrypt with public and decrypt with private key base64" do
    encrypted = RSA.encrypt_pub("hello", @pub, true)
    assert is_list(encrypted)

    assert "hello" == RSA.decrypt_priv(encrypted, @priv, true)
  end

  test "sign and verify" do
    signature = RSA.sign("hello", @priv)
    assert is_bitstring(signature)

    assert RSA.verify("hello",signature, @pub)
  end

  test "sign and verify base64" do
    signature = RSA.sign("hello", @priv, true)
    assert is_list(signature)

    assert RSA.verify("hello",signature, @pub, true)
  end

end
