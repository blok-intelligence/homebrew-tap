# Homebrew formula for the Seldon CLI.
#
# This is the TEMPLATE. The release-tap CircleCI job (scripts/update-homebrew-tap.sh) copies it to
# blok-intelligence/homebrew-tap on every cli-v* tag, rewriting `url` to the new npm tarball and
# recomputing `sha256`. The version pinned here is only a placeholder — CI overrides it.
#
#   brew install blok-intelligence/tap/seldon
class Seldon < Formula
  desc "Generate QA baselines from any codebase and run them from your terminal"
  homepage "https://github.com/blok-intelligence/blok-sdk"
  url "https://registry.npmjs.org/@seldonqa/cli/-/cli-0.6.7.tgz"
  sha256 "3e189fc818034f96869599c21b1182b28b3c7466a99283c1b6a1ad92bd314574"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    # Homebrew's std npm args add a supply-chain delay (--min-release-age) that refuses packages
    # published in the last ~24h — which blocks the freshly-released native binary carried in
    # optionalDependencies, so a brew install right after a release would fall back to the launcher.
    # Install the matching first-party platform package directly (no delay, still an opaque native
    # binary — no source exposed) so `brew install` gets the real binary immediately.
    cli_dir = "#{libexec}/lib/node_modules/@seldonqa/cli"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    platform = OS.mac? ? "darwin" : "linux"
    # Install as a GLOBAL package into the same prefix (not --prefix cli_dir): a plain install would
    # re-resolve the stub's package.json and try to fetch its workspace-only devDependency @blok/sdk
    # (unpublished → 404). The platform package has no deps, so a global install just drops the binary
    # alongside the stub, where postinstall finds it by walking up node_modules.
    system "npm", "install", "--global", "--prefix", libexec, "--no-audit", "--no-fund",
           "@seldonqa/cli-#{platform}-#{arch}@#{version}"

    # Copy the native binary over the bin/seldon launcher placeholder.
    system "node", "#{cli_dir}/postinstall.cjs"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "seldon", shell_output("#{bin}/seldon --help")
  end
end
