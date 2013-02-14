require 'nokogiri'
require 'open-uri'

def is_cap?(el)
  return (el['href'].index('scanlation').nil? and el.content.length < 11)
end

def id(el)
  return el['href'].split('/').last
end

def cap_view(view_url)
  return Nokogiri::HTML(open(view_url))
end

def dirname(el)
  return el.content.downcase.split(' ').join('_')
end

view_url = "http://submanga.com/c/%d/%d"

caps = Nokogiri::HTML(open('http://submanga.com/Naruto/completa')).css('.caps a').select{|l| not l['href'].nil? }.select { |l| is_cap?(l) }

p "Hay #{caps.length}"

caps.each do |c|
  pages = cap_view(view_url % [id(c), 1]).css('select').children.length
  dir_name = dirname(c)
  unless Dir.exist? dir_name
    Dir.mkdir(dir_name)

    p '#################################################'
    p "el capitulo #{dir_name} tiene #{pages} paginas/imagenes"

    [*1..pages].each do |page|
      v_url = view_url % [id(c), page]
      cap = cap_view(v_url) rescue nil
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

p 'me fui'
exit
