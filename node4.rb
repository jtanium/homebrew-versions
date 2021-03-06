require 'formula'

class Node4 < Formula
  homepage 'http://nodejs.org/'
  url 'http://nodejs.org/dist/node-v0.4.12.tar.gz'
  sha1 '1c6e34b90ad6b989658ee85e0d0cb16797b16460'

  head 'https://github.com/joyent/node.git'

  # Leopard OpenSSL is not new enough, so use our keg-only one
  depends_on 'openssl' if MacOS.version == :leopard

  fails_with(:llvm) { build 2326 }

  def options
    [["--enable-debug", "Build with debugger hooks."]]
  end

  def install
    inreplace 'wscript' do |s|
      s.gsub! '/usr/local', HOMEBREW_PREFIX
      s.gsub! '/opt/local/lib', '/usr/lib'
    end

    args = ["--prefix=#{prefix}"]
    args << "--debug" if ARGV.include? '--enable-debug'

    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    For node to pick up installed libraries, add this to your profile:
      export NODE_PATH=#{HOMEBREW_PREFIX}/lib/node_modules
    EOS
  end
end
