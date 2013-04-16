require 'formula'

class Msp430Binutils < Formula
  homepage 'http://mspgcc.sourceforge.net/'
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.21.1a.tar.bz2'
  version '20120406'
  sha256  'cdecfa69f02aa7b05fbcdf678e33137151f361313b2f3e48aba925f64eabf654'
  head 'git://mspgcc.git.sourceforge.net/gitroot/mspgcc/binutils'

  depends_on 'wangdong/msp430/msp430mcu'

  devel do
    url 'http://ftpmirror.gnu.org/binutils/binutils-2.22.tar.bz2'
    version '20120911'
    sha256 '6c7af8ed1c8cf9b4b9d6e6fe09a3e1d3d479fe63984ba8b9b26bf356b6313ca9'
  end

  option 'enable-libbfd', 'enable installation of libbfd.'

  def patches
    if build.devel?
      { :p1 => 'http://sourceforge.net/projects/mspgcc/files/Patches/binutils-2.22/msp430-binutils-2.22-20120911.patch/download' }
    elsif !build.head?
      { :p1 => 'http://sourceforge.net/projects/mspgcc/files/Patches/binutils-2.21.1a/msp430-binutils-2.21.1a-20120406.patch/download' }
    end
  end

  def install

    args = ["--prefix=#{prefix}",
            "--infodir=#{info}",
            "--mandir=#{man}",
            "--disable-werror",
            "--disable-nls"]

    if build.include? 'enable-libbfd'
      cd "bfd" do
        ohai "building libbfd"
        system "./configure", "--enable-install-libbfd", *args
        system "make"
        system "make install"
      end
    end

    system "./configure", "--target=msp430", *args

    system "make"
    system "make install"

    multios = `gcc --print-multi-os-dir`.chomp

    # binutils already has a libiberty.a. We remove ours, because
    # otherwise, the symlinking of the keg fails
    ohai "checking...#{HOMEBREW_PREFIX + 'lib' + multios + 'libiberty.a'}"
    File.unlink "#{lib}/#{multios}/libiberty.a" if File.exist? HOMEBREW_PREFIX + 'lib' + multios + 'libiberty.a'
  end
end
