require_relative "lib/music-player"

require 'rainbow/refinement'
using Rainbow

class Menu
  def initialize
    @music_player = MusicPlayer.new()
  end

  def start_player
    system("clear")
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
      6. Create Playlist\n
      7. Quit\n\n".green

      puts "Your selection: ".cyan

      selection = gets().chomp.to_i
      break if selection > 0 and selection <= 7

      puts "The option you chose is unavailable.\n".red
      
      show_continue()
    end

    system "clear"

    case selection
    when 1
      show_upload_menu()
    when 2
      show_delete()
    when 3
      show_change_location()
    when 4
      show_sort_menu()
    when 5
      show_play()
    when 6
      show_create_playlist()
    when 7
      show_exit
    end

  end

  def show_upload_menu
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
    show_upload(selection)
  end

  def show_upload(selection)

    system "clear"

    case selection
    when 1
      path = input_song()
      @music_player.upload_song(path)

      puts "Song successfully added to the playlist.".green.bright
    when 2
      path, files, selection_list = input_album()
      @music_player.upload_album(path, files, selection_list)

      puts "Album successfully added.".green.bright
    when 3
      path = input_playlist()
      @music_player.upload_playlist(path)

      puts "Playlist successfully added.".green.bright
    when 4
      show_main()
    end

    show_continue()
    show_upload_menu()
  end

  def show_delete
    
    if @music_player.song_list.length == 0
      show_empty_list()
    end 

    selection = input_deletion()
    
    @music_player.delete_song(selection)

    system "clear"

    show_main()
  end

  def show_change_location()

    if @music_player.song_list.length == 0
      show_empty_list()
    end 

    selection, location = input_location_change()

    @music_player.change_song_location(selection, location)

    puts "Song location successfully changed to #{location}.".green.bright

    system "clear"

    show_main()
  end

  def show_sort_menu()
    selection = nil

    loop do
      puts "Sort menu:\n
      1. By artist\n
      2. By track number\n".green

      puts "Your selection: ".cyan
      selection = gets().chomp.to_i

      break if selection > 0 and selection <= 2

      puts "The option you chose is unavailable.\n".red
      
      show_continue()
    end

    case selection
    when 1
      @music_player.sort_by_artist
    when 2
      @music_player.sort_by_track_number
    end

    show_main()
  end

  def show_create_playlist()
    if @music_player.song_list.length == 0
      show_empty_list()
    end

    name, selection_list = input_playlist_creation()

    puts "dab".red

    @music_player.create_playlist(name, selection_list)

    puts "Playlist was created successfully.".green.bright

    show_continue()
    show_main()
  end

  def show_play()
    
  end

  def show_exit()
    puts "Exiting the program.."
    exit(true)
  end

  def show_continue()
    puts "Press enter to continue."
    gets()
    system "clear"
  end

  def input_song()
    path = nil

      loop do
        puts "Specify PATH to the song:".green

        path = gets().chomp
        break if File.file?(path) and [".mp3", ".flac"].include?(File.extname(path).downcase)
        
        puts "File does not exist or wrong file format.".red
        
        show_continue()
      end

      return path
  end

  def input_album()
    puts "Specify PATH to the album:".green
    path = gets().chomp

    files = Dir.glob(path + "/*").select do | file |
      File.file?(file) && [".mp3", ".flac"].include?(File.extname(file).downcase)
    end

    puts "Song list:\n".green
    idx = 1
    for file in files do
      puts "#{idx}. #{file}".green
      idx += 1
    end

    selection_list = nil

    loop do
      
      puts "Select songs to upload: ".cyan
      puts "E.g. 1, 2, 4, 7 or 'all'".white.faint
      
      selection_list = gets().chomp

      if selection_list == "all"
        selection_list = (1..files.length).to_a

        return path, files, selection_list
      end

      selection_list = selection_list.split(",")

      is_valid = true

      for item in selection_list do
        item = item.to_i
        
        if not(item <= idx and item > 0)
          is_valid = false
        end
        
      end

      break if is_valid == true
      
      puts "Unable to add specified songs to the list.".red.bright
      puts "Press enter to continue."
      gets()
    end

    return path, files, selection_list
  end

  def input_playlist()
    path = nil

    loop do
      puts "Specify PATH to the playlist:".green

      path = gets().chomp

      break if File.file?(path) and [".json"].include?(File.extname(path).downcase)

      puts "File does not exist or wrong file format.".red

      show_continue()
    end

    return path
  end

  def input_location_change()
    selection = nil

    loop do
      puts "Select a song to relocate:\n".green
      show_song_list("#008000")

      puts "Your selection: ".cyan
      selection = gets().to_i

      break if selection > 0 and selection <= @music_player.song_list.length

      puts "The option you chose is unavailable.\n".red
 
      show_continue()
    end
    system("clear")

    location = nil

    loop do
      puts "Select a new location:".green

      puts "Your selection: ".cyan
      location = gets().to_i

      break if selection > 0 and selection <= @music_player.song_list.length

      puts "The option you chose is unavailable.\n".red
 
      show_continue()
    end

    return selection, location
  end

  def input_deletion()
    selection = nil

    loop do
      puts "Select a song to delete:\n".green
      show_song_list("#008000")

      puts "Your selection: ".cyan
      selection = gets().to_i

      break if selection > 0 and selection <= @music_player.song_list.length

      puts "The option you chose is unavailable.\n".red
 
      show_continue()
    end

    return selection
  end

  def input_playlist_creation()
    
    selection_list = nil

    loop do
      puts "Select songs to add to your playlist:".green

      show_song_list("#008000")

      puts "Select songs to upload: ".cyan
      puts "E.g. 1, 2, 4, 7 or 'all'".white.faint

      selection_list = gets().chomp

      selection_list = selection_list.split(",")

      is_valid = true

      for item in selection_list do
        
        item = item.to_i
        
        if not(item <= @music_player.song_list.length and item > 0)
          is_valid = false
        end
      end

      break if is_valid == true
      
      puts "Unable to add specified songs to the list.".red.bright
      show_continue()
    end

    puts "Select a name for your playlist:".green
    name = gets().chomp
    
    return name, selection_list
  end

  def show_song_list(chosen_color = "ffffff")
    array = @music_player.get_song_list
    
    i = 1
    for song in array
      puts "#{i}. #{song.artist} - #{song.title}".color(chosen_color)
      i += 1
    end
  end

  def show_empty_list()
    puts "There are no songs in this playlist.".red
    show_continue()
    show_main()
  end
end