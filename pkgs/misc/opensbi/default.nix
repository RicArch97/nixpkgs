{ lib
, stdenv
, fetchFromGitHub
, python3
, withPlatform ? "generic"
, withPayload ? null
, withFDT ? null
}:

stdenv.mkDerivation rec {
  pname = "opensbi";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = "opensbi";
    rev = "v${version}";
    sha256 = "sha256-Dr16fVUGLYGnGYHkjAyqpJxt8p95F0CJIU9ESGWKGWo=";
  };

  postPatch = ''
    patchShebangs ./scripts
  '';

  nativeBuildInputs = [ python3 ];

  installFlags = [
    "I=$(out)"
  ];

  makeFlags = [
    "PLATFORM=${withPlatform}"
  ] ++ lib.optionals (withPayload != null) [
    "FW_PAYLOAD_PATH=${withPayload}"
  ] ++ lib.optionals (withFDT != null) [
    "FW_FDT_PATH=${withFDT}"
  ];

  dontStrip = true;
  dontPatchELF = true;

  meta = with lib; {
    description = "RISC-V Open Source Supervisor Binary Interface";
    homepage = "https://github.com/riscv-software-src/opensbi";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ius nickcao zhaofengli ];
    platforms = [ "riscv64-linux" ];
  };
}
