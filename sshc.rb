URL = "#{File.dirname(__FILE__)}/aws-instances"

def connect
  servers = File.open(URL, 'r') { |f| f.map(&:strip) }
  servers = servers.map { |s| s.split(",") }

  puts "Select instance:\n\n"
  servers.each.with_index(1) do |server, idx|
    puts "#{idx}) #{server.first}"
  end
  print "\n> "

  choice = STDIN.gets.to_i
  exit unless choice.between?(1, servers.size)
  server = servers[choice - 1]

  puts "\nssh #{server[1]}@#{server[2]}"
  exec "ssh #{server[1]}@#{server[2]}"
rescue Interrupt
  exit
end

def add_instance(name = "", user = "", ip = "")
  name = prompt_add(name, "Name")
  user = prompt_add(user, "User")
  ip = prompt_add(ip, "IP")

  print "Add #{name} for #{user}@#{ip}? (Y/n) "

  confirm = STDIN.gets.chomp.downcase
  case
  when confirm == "y", confirm.empty?
    puts "OK!"
    File.open(URL, 'a') { |f| f << "#{name},#{user},#{ip}\n" }
  when confirm == "n"
    add_instance(name, user, ip)
  end
rescue Interrupt
  exit
end

def list
  servers = File.open(URL, 'r') { |f| f.map(&:strip) }
  servers = servers.map { |s| s.split(",") }
  return if servers.nil?
  widths = [servers.map(&:first).max_by(&:length).length + 2,
            servers.map{|s|s[1]}.max_by(&:length).length + 2]
  pretty("NAME", "USER", "IP", widths)
  servers.each do |s|
    pretty(s[0], s[1], s[2], widths)
  end
end

def prompt_add(value, string)
  print value.empty? ? "#{string}: " : "#{string} (#{value}): "
  tmp_value = STDIN.gets.chomp 
  tmp_value.empty? ? value : tmp_value
end

def pretty(name, user, ip, widths)
  printf "%-#{widths[0]}s %-#{widths[1]}s %s\n", name, user, ip
end

case ARGV.first
when "add"
  add_instance
  exit
when "list"
  list
  exit
end

connect

