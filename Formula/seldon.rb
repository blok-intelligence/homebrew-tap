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
    # Run postinstall explicitly to copy the native binary into bin/seldon,
    # in case npm skipped lifecycle scripts.
    system "node", "#{libexec}/lib/node_modules/@seldonqa/cli/postinstall.cjs"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "seldon", shell_output("#{bin}/seldon --help")
  end
end
