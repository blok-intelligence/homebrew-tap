# Homebrew formula for the Seldon CLI.
#
# Published to the tap repo blok-intelligence/homebrew-tap by the release-cli CircleCI workflow,
# which bumps `url` to the new npm tarball and recomputes `sha256`.
#
#   brew install blok-intelligence/tap/seldon
class Seldon < Formula
  desc "Generate QA baselines from any codebase and run them from your terminal"
  homepage "https://github.com/blok-intelligence/blok-sdk"
  url "https://registry.npmjs.org/@seldonqa/cli/-/cli-0.6.0.tgz"
  sha256 "72ed1353c817fe459383a06bf8ca7bb6de01f97fd812317e4d007fb727e89fb0"
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
