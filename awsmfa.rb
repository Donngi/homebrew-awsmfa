class Awsmfa < Formula
  desc "Simple cli tool for AWS MFA (multi factor authentication)"
  homepage "https://github.com/Jimon-s/awsmfa"
  url "https://github.com/Jimon-s/awsmfa/archive/v1.0.3.tar.gz"
  sha256 "42a4a60c46b834275163614a92353944425dafabf20cef412228f5852475f0db"
  license "MIT"

  depends_on "go" => :build

  def install
    # Install awsmfa command
    system "go", "build"
    bin.install "awsmfa"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/awsmfa", "completion", "bash")
    (bash_completion/"awsmfa").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/awsmfa", "completion", "zsh")
    (zsh_completion/"_awsmfa").write output
  end

  test do
    run_output = shell_output("#{bin}/awsmfa --generate-credentials-skeleton get-session-token")
    want = "[sample-before-mfa]\n\
aws_access_key_id     = YOUR_ACCESS_KEY_ID_HERE!!!\n\
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY_HERE!!!\n"
    assert_match want, run_output
  end
end
