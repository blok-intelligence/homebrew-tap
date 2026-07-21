# Homebrew formula for the Seldon CLI.
#
# Published to the tap repo blok-intelligence/homebrew-tap by the release-cli CircleCI workflow,
# which bumps `url` to the new npm tarball and recomputes `sha256`.
#
#   brew install blok-intelligence/tap/seldon
class Seldon < Formula
  desc "Generate QA baselines from any codebase and run them from your terminal"
  homepage "https://github.com/blok-intelligence/blok-sdk"
  url "https://registry.npmjs.org/@seldonqa/cli/-/cli-0.6.2.tgz"
  sha256 "3ce5ccd984510a1db2c99742723e3c099e4bb10ab6f50a3b5c8ca25f77455b2a"
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
