require_relative "lib/music-player"

require 'rainbow/refinement'
using Rainbow

class Menu
  def initialize
    @music_player = MusicPlayer.new()
  end

  def start_player
    show_main()
  end

  def show_main
    
    selection = nil

    loop do
      puts " " * 5 + "Music player\n".magenta

      puts "Selection menu:\n
      1. Upload Songs\n
      2. Delete Songs\n
      3. Change Song Location\n
      4. Sort Songs\n
      5. Play Songs\n
      6. Quit\n\n".green

      puts "Your selection: ".cyan

      selection = gets().chomp.to_i
      break if selection > 0 and selection <= 6

      puts "The option you chose is unavailable.\n".red
      
      show_continue()
    end

    system "clear"

    case selection
    when 1
      show_upload()
    when 2
      show_delete()
    when 3
      show_change_location()
    when 4
      show_sort()
    when 5
      show_play()
    when 6
      show_exit
    end

  end

  def show_upload
    
    selection = nil

    loop do
      puts "Upload menu:\n
      1. Upload a Song\n
      2. Upload an Album\n
      3. Upload a Playlist\n
      4. Return to Main Menu\n".green

      puts "Your selection: ".cyan
      selection = gets().chomp.to_i

      break if selection > 0 and selection <= 4

      puts "The option you chose is unavailable.\n".red
      
      show_continue()
    end 

    system "clear"

    case selection
    when 1
      @music_player.upload_song()

      puts "Song successfully added to the playlist.".green.bright

      show_continue()
      show_upload()
    when 2
      @music_player.upload_album()

      puts "Album successfully added.".green.bright

      show_continue()
      show_upload()
    when 3
      @music_player.upload_playlist()

      puts "Playlist successfully added.".green.bright

      show_continue()
      show_upload()
    when 4
      show_main()
    end

  end

  def show_delete
    
    selection = nil
    
    loop do
      puts "Select a song to delete:\n".green

      puts @music_player.song_list.length
      puts @music_player.list_songs()

      puts "Your selection: ".cyan
      selection = gets().chomp.to_i

      puts "#{selection}".red

      break if selection > 0 and selection <= @music_player.song_list.length

      puts "The option you chose is unavailable.\n".red
      
      show_continue()
    end 

    system "clear"
  end

  def show_change_location
    
  end

  def show_sort
    
  end

  def show_play
    
  end

  def show_exit
    puts "Exiting the program.."
    exit(true)
  end

  def show_continue()
    puts "Press enter to continue."
    gets()
    system "clear"
  end
end