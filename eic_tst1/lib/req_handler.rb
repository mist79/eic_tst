class ReqHandler
  @@logger = Logger.new(STDOUT)

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  # white list
  ACTION_MAPPINGS = {
    'home#index'    => :home_index_process,
    'home#do_stuff' => :do_stuff_process,
    'default'       => :default_handler
  }

  def process
    params = @request.params
    controller = params['controller']
    action = params['action']

    # независимо от того, нужно ли что-либо делать, выводим сообщение в лог
    log(controller, action)
    # собственно обработка запроса - вызов запрошенного метода или обработка по дефолту
    result = send(ACTION_MAPPINGS["#{controller}##{action}"] || ACTION_MAPPINGS['default'])
    # формируем Rack-ответ
    answer(result)
  end

  def log(controller, action)
    @@logger.info "============= requested process: controller: '#{ controller }', action: '#{action}' ============="
  end

  def answer(answer_body = '')
    [200, {}, [answer_body.to_s]]
  end

  def home_index_process
    # do nothing for this action
    'it works - do nothing.'
  end

  def do_stuff_process
    # do some stuff.....
    'it works - some stuff did.'
  end

  def default_handler
    # do nothing for default
    nil
  end

  # если в ACTION_MAPPINGS определен несуществующий метод - обрабатываем дефолтным
  def method_missing(meth_name)
    default_handler
    # super не вызываем, так как дефолтный обработчик обрабатывает все..
  end

end
