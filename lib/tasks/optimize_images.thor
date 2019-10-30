class Admin < Thor
  desc 'optimize_images', 'optimize images' 
  def optimize_images
    Dir['app/assets/**/*.png'].each do |png|
      puts "Optimizing #{png}"
      #puts `optipng -fix -preserve #{png}`
      puts `pngcrush -rem alla -fix -oldtimestamp #{png} #{png}.tmp; mv #{png}.tmp #{png}`       
    end
    Dir['app/assets/**/*.jpg'].each do |jpg|
      puts "Optimizing #{jpg}"
      puts `jpegoptim --strip-all --preserve #{jpg}`
    end
  end
end
