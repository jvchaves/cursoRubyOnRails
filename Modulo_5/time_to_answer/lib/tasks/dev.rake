namespace :dev do
  DEFAULT_PASSWORD = 123456
  desc "Configurando o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") { %x(rails db:drop)}
      show_spinner("Criando BD...") { %x(rails db:create)}
      show_spinner("Migrando BD...") { %x(rails db:migrate)}
      show_spinner("Cadastrando o adiministrador padrão") { %x(rails dev:add_default_admin)}
      show_spinner("Cadastrando o usuario padrão") { %x(rails dev:add_default_user)}
    else
      puts "Você não esta em ambiente de desenvolvimento"
    end
  end

  desc "Adicionando o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end
  desc "Adicionando o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end



private

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
     yield
    spinner.success("(#{msg_end})")
  end
end
