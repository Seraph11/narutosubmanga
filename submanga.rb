require 'nokogiri'
require 'open-uri'


class Submanga
  VIEW_URL = "http://submanga.com/c/%d/%d".freeze

  def initialize(serie_url)
    @serie_url = serie_url # 'http://submanga.com/Naruto/completa'
  end

  def is_chapter?(el)
    el.content.length < 11
  end

  def id(el)
    el['href'].split('/').last
  end

  def chapter_view(view_url)
    Nokogiri::HTML(open(view_url))
  end

  def dirname(el)
    el.content.downcase.split(' ').join('_')
  end

  def chapters
    Nokogiri::HTML(open(@serie_url)).css('.caps a[href]:not([href*=scanlation])').select { |l| is_chapter?(l) }
  end

  def download_chapters
    chapters.each do |chapter|
      pages = chapter_view(VIEW_URL % [id(chapter), 1]).css('select').children.length
      dir_name = dirname(chapter)
      unless Dir.exist? dir_name
        Dir.mkdir(dir_name)

        p '#################################################'
        p "el capitulo #{dir_name} tiene #{pages} paginas/imagenes"

        [*1..pages].each do |page|
          v_url = VIEW_URL % [id(chapter), page]
          cap = chapter_view(v_url) rescue nil
          unless cap.nil?
            img = cap.css('img').select{ |i| i['src'].index('.jpg')}.first['src'] 
            %x[wget #{img}]
          else
            p "#{v_url} no se pudo abrir :("
          end
        end
        %x[mv *.jpg #{dir_name}]
        p 'Images bajadas y movidas al directorio que tal. Chequeando el numero de imagenes'
        puts %x[ls #{dir_name} | wc -l].chop.to_i == pages.to_i ? 'Todas las imagenes fueron descargadas!' : 'oops! No se bajaron todas'
        puts '-------------------------------------------'
      end
    end
  end
end

sbm = Submanga.new 'http://submanga.com/Naruto/completa'
sbm.download_chapters