# encoding: UTF-8

require 'singleton'
class PdfConverter
  
  include Singleton

  def converter(source_path, file_name='my_document')
    convert = %x[which convert].strip
    return nil unless File.exists? convert

    source_path = source_path.strip.chomp('/')
    return nil unless Dir.exists? source_path
    system("convert #{sanitize(source_path)}/*.??g #{sanitize(source_path)}/#{sanitize(file_name)}.pdf")
  end

  def sanitize(str)
    Regexp.escape(str).gsub(/'/,"\\\\'")
  end
  
end
