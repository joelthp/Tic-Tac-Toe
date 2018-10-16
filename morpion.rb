require 'colorize'

class Board
# on cree un array avec des hashs comportant les cases vides
    @@rows = [@@row1 = {:a1 => ' ', :b1 => ' ', :c1 => ' '},
              @@row2 = {:a2 => ' ', :b2 => ' ', :c2 => ' '},
              @@row3 = {:a3 => ' ', :b3 => ' ', :c3 => ' '}]
 
    def initialize
# on definit le constructeur avec les variables d'instances
        puts "Joueurs créés...".colorize(:blue)
        puts "La partie va commencer...".colorize(:blue)
        @win = false
        @draw = false
        @@turn = 1
        display
    end

# Explication du jeu
    def display
        puts "=== MORPION ===".colorize(:red)
        puts "Il suffit d'entrer son numero de case".colorize(:red) 
        puts "Par exemple : A2".colorize(:red)           
        puts "===================".colorize(:red)  
        drawBoard
    end

# On affiche le tableau
    def drawBoard
        puts "===================".colorize(:blue)
        puts "Tour #{@@turn}".colorize(:red)  
        puts "     A    B    C    ".colorize(:blue)
        puts "   --------------  ".colorize(:red)  
        puts " |  #{@@row1[:a1]}  |  #{@@row1[:b1]}   |  #{@@row1[:c1]} | 1 ".colorize(:blue)
        puts "   --------------  ".colorize(:red)  
        puts " |  #{@@row2[:a2]}  |  #{@@row2[:b2]}   |  #{@@row2[:c2]} | 2 ".colorize(:blue)
        puts "   --------------  ".colorize(:red)  
        puts " | #{@@row3[:a3]}  |  #{@@row3[:b3]}   |  #{@@row3[:c3]} |  3 ".colorize(:blue)

    end

# Permet de savoir si il doit mettre un "X" ou un "O"
    def select(casse)
        @@rows.each do |row|
            row.each do|key, value|
                if key == casse && value == ' '
                   if @@turn.odd? then row[key] = "X"  else row[key] = "O"  end
                    @@turn += 1
                end
            end
        end
    end

# On decrit les combinaisons gagnantes.
    def check_board
        x_wins = ["X", "X", "X"]
        o_wins = ["O", "O", "O"]

        winning_rows = [            
            [@@row1[:a1],@@row2[:a2],@@row3[:a3]],
      [@@row1[:b1],@@row2[:b2],@@row3[:b3]],
      [@@row1[:c1],@@row2[:c2],@@row3[:c3]],
      [@@row1[:a1],@@row1[:b1],@@row1[:c1]],
      [@@row2[:a2],@@row2[:b2],@@row2[:c2]],
      [@@row3[:a3],@@row3[:b3],@@row3[:c3]],
      [@@row1[:a1],@@row2[:b2],@@row3[:c3]],
      [@@row3[:a3],@@row2[:b2],@@row1[:c1]]     
        ]

        winning_rows.each do |match|
            if match == x_wins || match == o_wins
                @win = true
            end
        end

        if @@turn >=9
            @draw = true
        end
    end

    def win
        @win
    end 


    def draw
        @draw
    end        

end


class Player
    attr_accessor :name

    def initialize(name)
        @name = name
    end
end


class Game
# on cree 2 joueurs et un tableau.
    def initialize
        @player1 = Player.new(player_name(1))
        @player2 = Player.new(player_name(2))
        @current_player = @player2

        @selected_values = []

        @board = Board.new
        @game_on = true
        play_game
    end
 
 # on demande aux joueurs leurs nom avant de commencer.
    def player_name(num)
        puts "Joueur numero #{num}, quel est votre nom ?"
        gets.chomp
    end


    def play_game
        while @game_on
        # On demande au joueur de choisir une case 
            puts "Quel case choisis tu #{@current_player.name} ?".colorize(:yellow)  
            cell = gets.chomp.to_sym.downcase
        # Si une case est deja prise, on demande au joueur d'en choisir une autre
           while cell.match(/[^a-c1-3]/) || @selected_values.include?(cell)
                puts "Case deja prise, choisis en une autre !".colorize(:yellow)  
                cell = gets.chomp.to_sym
            end

            @selected_values << cell
            @board.select(cell)
            @board.drawBoard
            @board.check_board
            if @board.win
                puts "Le gagnant est #{@current_player.name}!".colorize(:yellow)  
               exit
            elsif @board.draw
                puts "Egalite !".colorize(:yellow)  
             exit
            end
            switch_cur_player
        end
    end

# Pour savoir a qui c'est le tour.
    def switch_cur_player
       if @current_player == @player1 then @current_player = @player2 else @current_player = @player1 end
    end
end

# on lance le jeu !!
newGame = Game.new
