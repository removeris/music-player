require_relative "data-structures/doubly-linked-list"
require_relative "data-structures/linked-list"
require_relative "song"

require 'rainbow/refinement'
require 'taglib'

using Rainbow

class MusicPlayer
  attr_accessor :song_list
  
  def initialize
    @song_list = DataStructure::DoublyLinkedList.new('2')
  end

  def list_songs()
    array = []

    i = 0
    while i < @song_list.length
      array[i] = @song_list.get(i).value
      i += 1
    end

    for song in array
      puts song.value
    end
  end

  def upload_song()
    path = nil
    loop do
      puts "Specify PATH to the song:".green

      path = gets().chomp
      break if File.file?(path) && [".mp3", ".flac"].include?(File.extname(path).downcase)
      puts "File does not exist or wrong file format.".red
      
      puts "Press enter to continue."
      gets()
      system "clear"
    end
    
    new_song = Song.new()
    new_song.path = path
    
    TagLib::MPEG::File.open(path) do | file |
      tag = file.id3v2_tag
      
      new_song.title = tag.title
      new_song.artist = tag.artist
      new_song.duration = file.audio_properties.length_in_seconds
    end

    @song_list.push(new_song)
  end

  def upload_album()
    puts "Specify PATH to the album:\n"
    path = gets().chomp

    files = Dir.glob(path + "/*").select do | file |
      File.file?(file) && [".mp3", ".flac"].include?(File.extname(file).downcase)
    end

    puts files
  end

  def upload_playlist()
    
  end

end