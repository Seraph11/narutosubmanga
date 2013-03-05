class Downloader < Hash 

  attr_accessor :directory

  def run
    raise 'Tienes que especificar un directorio de descarga!' unless @directory
    each_pair do |url, downloaded|
      download(url)
      self[url] = true # muy mal este método, muy mal...
    end
  end

  def add(url)
    added = false
    if url # validar url
      self[url] = false # no ha sido descargada
      added = true
    end
    added
  end
  
  def directory=(directory)
    return nil unless Dir.exists?(directory)
    @directory = directory
  end

  def downloaded_all?
    !empty? && !has_value?(false)
  end

private
  def download(image_url)
    return nil unless directory
    %x[wget #{image_url} -O /#{directory}/#{File.basename(image_url)} -t 5 -nv] # chequear que se bajó
  end
end

# https://www.google.com/images/srpr/logo3w.png
