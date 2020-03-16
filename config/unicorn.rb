#サーバ上でのアプリケーションコードが設置されているディレクトリを変数に入れておく
app_path = File.expand_path('../../../', __FILE__)
#capistrano導入に伴い変化するディレクトリ構造に対応するため、../をふやしています。

#アプリケーションサーバの性能を決定する
worker_processes 1

#アプリケーションの設置されているディレクトリを指定
working_directory "#{app_path}/current"
#capistrano導入に伴い、最新の本番環境はcat_or_dog/currentに入るため、working_directroyを変更

#Unicornの起動に必要なファイルの設置場所を指定
pid "#{app_path}/shared/tmp/pids/unicorn.pid"
#capistrano導入に伴い、sharedディレクトリ内にある、unicorn.pidファイルを読むよう変更。

#ポート番号を指定
#listen 3000
#ポート番号3000で待つのではなく、nginxからアクセスされた場合になるよう変更
listen "#{app_path}/shared/tmp/sockets/unicorn.sock"
#capistrano導入に伴い、sharedディレクトリ内にある、sockファイルを読むよう変更。

#エラーのログを記録するファイルを指定
stderr_path "#{app_path}/shared/log/unicorn.stderr.log"
#capistrano導入に伴い、sharedディレクトリ内にあるunicorn.stderr.logを読むよう変更。

#通常のログを記録するファイルを指定
stdout_path "#{app_path}/shared/log/unicorn.stdout.log"
#capistrano導入に伴い、sharedディレクトリ内にあるunicorn.stdout.logを読むよう変更。

#Railsアプリケーションの応答を待つ上限時間を設定
timeout 60

#以下は応用的な設定なので説明は割愛

preload_app true
GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true

check_client_connection false

run_once = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!

  if run_once
    run_once = false # prevent from firing again
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => e
      logger.error e
    end
  end
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end