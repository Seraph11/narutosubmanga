# encoding: UTF-8
require 'singleton'
require 'zip/zip'
class CbzConverter

  include Singleton
  
  def converter(source_path, file_name='out')
    # Verificar si existe la ruta
    source_path = source_path.strip.chomp('/')
    return nil unless Dir.exists? source_path
    # Hacer el cbz con las imágenes
    Zip::ZipFile.open(source_path + '/' + file_name + '.cbz', Zip::ZipFile::CREATE) do |zipfile|
      Dir.entries(source_path).each do |file|
        zipfile.add(file, source_path + '/' + file) if file.end_with?('jpg','png')
      end
    end
    # retornamos si se creo el archivo o no
    File.exists?(source_path + '/' + file_name + '.cbz')
  end
end