<?php
/**
*@package pXP
*@file gen-MODIntTransaccion.php
*@author  (admin)
*@date 01-09-2013 18:10:12
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODIntTransaccion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarIntTransaccion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_INTRANSA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_moneda','id_moneda','int4');
		
		//captura parametros adicionales para el count
		$this->capturaCount('total_debe','numeric');
		$this->capturaCount('total_haber','numeric');
		$this->capturaCount('total_debe_mb','numeric');
		$this->capturaCount('total_haber_mb','numeric');
		$this->capturaCount('total_debe_mt','numeric');
		$this->capturaCount('total_haber_mt','numeric');
		$this->capturaCount('total_debe_ma','numeric');
		$this->capturaCount('total_haber_ma','numeric');
		$this->capturaCount('total_gasto','numeric');
		$this->capturaCount('total_recurso','numeric');
		
				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_transaccion','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_int_transaccion_fk','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('glosa','varchar');
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');		
		$this->captura('desc_partida','text');
		$this->captura('desc_centro_costo','text');
		$this->captura('desc_cuenta','text');
		$this->captura('desc_auxiliar','text');
		$this->captura('tipo_partida','varchar');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('desc_orden','varchar');
		$this->captura('importe_debe','numeric');	
		$this->captura('importe_haber','numeric');
		$this->captura('importe_gasto','numeric');
		$this->captura('importe_recurso','numeric');
		
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_gasto_mb','numeric');
		$this->captura('importe_recurso_mb','numeric');
		
		$this->captura('banco','varchar');
		$this->captura('forma_pago','varchar');
		$this->captura('nombre_cheque_trans','varchar');
		$this->captura('nro_cuenta_bancaria_trans','varchar');
		$this->captura('nro_cheque','INTEGER');
		
		$this->captura('importe_debe_mt','numeric');	
        $this->captura('importe_haber_mt','numeric');
        $this->captura('importe_gasto_mt','numeric');
        $this->captura('importe_recurso_mt','numeric');
		
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('importe_gasto_ma','numeric');
		$this->captura('importe_recurso_ma','numeric');
		
        $this->captura('id_moneda_tri','INTEGER');
        $this->captura('id_moneda_act','INTEGER');
        $this->captura('id_moneda','INTEGER');
		
        $this->captura('tipo_cambio','numeric');
        $this->captura('tipo_cambio_2','numeric');
        $this->captura('tipo_cambio_3','numeric');
		
		$this->captura('actualizacion','varchar');
		$this->captura('triangulacion','varchar');
		$this->captura('id_suborden','int4');
		$this->captura('desc_suborden','varchar');
		$this->captura('codigo_ot','varchar');
		$this->captura('codigo_categoria','varchar');
		
		
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarIntTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_transaccion_ime';
		$this->transaccion='CONTA_INTRANSA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_int_transaccion_fk','id_int_transaccion_fk','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('glosa','glosa','varchar');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		
		$this->setParametro('importe_debe','importe_debe','numeric');
		$this->setParametro('importe_haber','importe_haber','numeric');
		$this->setParametro('importe_gasto','importe_gasto','numeric');
		$this->setParametro('importe_recurso','importe_recurso','numeric');
		
		$this->setParametro('importe_debe_mb','importe_debe','numeric');
		$this->setParametro('importe_haber_mb','importe_haber','numeric');
		$this->setParametro('importe_gasto_mb','importe_gasto','numeric');
		$this->setParametro('importe_recurso_mb','importe_recurso','numeric');
		
		$this->setParametro('id_moneda_tri','id_moneda_tri','INTEGER');		
		$this->setParametro('id_moneda_act','id_moneda_act','INTEGER');
        $this->setParametro('id_moneda','id_moneda','INTEGER');
        $this->setParametro('tipo_cambio','tipo_cambio','numeric');
        $this->setParametro('tipo_cambio_2','tipo_cambio_2','numeric');
        $this->setParametro('tipo_cambio_3','tipo_cambio_3','numeric');
		$this->setParametro('id_suborden','id_suborden','int4');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarIntTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_transaccion_ime';
		$this->transaccion='CONTA_INTRANSA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_transaccion','id_int_transaccion','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_int_transaccion_fk','id_int_transaccion_fk','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('glosa','glosa','text');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		
		$this->setParametro('importe_debe','importe_debe','numeric');
		$this->setParametro('importe_haber','importe_haber','numeric');
		$this->setParametro('importe_gasto','importe_gasto','numeric');
		$this->setParametro('importe_recurso','importe_recurso','numeric');
		
		$this->setParametro('importe_debe_mb','importe_debe','numeric');
		$this->setParametro('importe_haber_mb','importe_haber','numeric');
		$this->setParametro('importe_gasto_mb','importe_gasto','numeric');
		$this->setParametro('importe_recurso_mb','importe_recurso','numeric');
		
		$this->setParametro('id_moneda_tri','id_moneda_tri','INTEGER');
		$this->setParametro('id_moneda_act','id_moneda_act','INTEGER');
        $this->setParametro('id_moneda','id_moneda','INTEGER');
        $this->setParametro('tipo_cambio','tipo_cambio','numeric');
        $this->setParametro('tipo_cambio_2','tipo_cambio_2','numeric');
		$this->setParametro('tipo_cambio_3','tipo_cambio_3','numeric');
		$this->setParametro('id_suborden','id_suborden','int4');
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarIntTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_transaccion_ime';
		$this->transaccion='CONTA_INTRANSA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_transaccion','id_int_transaccion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

   function guardarDatosBancos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_transaccion_ime';
		$this->transaccion='CONTA_SAVTRABAN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_transaccion','id_int_transaccion','int4');
		$this->setParametro('nombre_cheque_trans','nombre_cheque_trans','varchar');
		$this->setParametro('forma_pago','forma_pago','varchar');
		$this->setParametro('nro_cheque','nro_cheque','int4');		
		$this->setParametro('nro_cuenta_bancaria','nro_cuenta_bancaria','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}


   function listarIntTransaccionMayor(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_INTMAY_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('tipo_filtro','tipo_filtro','varchar');
		
		
		//captura parametros adicionales para el count
		$this->capturaCount('total_debe','numeric');
		$this->capturaCount('total_haber','numeric');
		$this->capturaCount('total_debe_mt','numeric');
		$this->capturaCount('total_haber_mt','numeric');
		$this->capturaCount('total_debe_ma','numeric');
		$this->capturaCount('total_haber_ma','numeric');
		
		
				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_transaccion','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_int_transaccion_fk','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('glosa','varchar');
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_gasto_mb','numeric');
		$this->captura('importe_recurso_mb','numeric');
		
		$this->captura('importe_debe_mt','numeric');	
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_gasto_mt','numeric');
		$this->captura('importe_recurso_mt','numeric');
		
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('importe_gasto_ma','numeric');
		$this->captura('importe_recurso_ma','numeric');
		
		$this->captura('desc_partida','text');
		$this->captura('desc_centro_costo','text');
		$this->captura('desc_cuenta','text');
		$this->captura('desc_auxiliar','text');
		$this->captura('tipo_partida','varchar');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('desc_orden','varchar');		
		$this->captura('nro_cbte','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('nombre_corto','varchar');
		$this->captura('fecha','date');
		$this->captura('glosa1','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		 
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

   function listarIntTransaccionOrden(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_INTANA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		
		//captura parametros adicionales para el count
		$this->capturaCount('total_debe','numeric');
		$this->capturaCount('total_haber','numeric');
		$this->capturaCount('total_debe_mt','numeric');
		$this->capturaCount('total_haber_mt','numeric');
		$this->capturaCount('total_debe_ma','numeric');
		$this->capturaCount('total_haber_ma','numeric');
			
		//Definicion de la lista del resultado del query
		$this->captura('id_orden_trabajo','int4');
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_debe_mt','numeric');	
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('codigo_ot','varchar');
		$this->captura('desc_orden','varchar');
		
		 
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarIntTransaccionPartida(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_INTPAR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		
		//captura parametros adicionales para el count
		$this->capturaCount('total_debe','numeric');
		$this->capturaCount('total_haber','numeric');
		$this->capturaCount('total_debe_mt','numeric');
		$this->capturaCount('total_haber_mt','numeric');
		$this->capturaCount('total_debe_ma','numeric');
		$this->capturaCount('total_haber_ma','numeric');
			
		//Definicion de la lista del resultado del query
		$this->captura('id_partida','int4');
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_debe_mt','numeric');	
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('codigo_partida','varchar');
		$this->captura('sw_movimiento','varchar');
		$this->captura('descripcion_partida','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

     function listarIntTransaccionCuenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_INTCUE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		
		//captura parametros adicionales para el count
		$this->capturaCount('total_debe','numeric');
		$this->capturaCount('total_haber','numeric');
		$this->capturaCount('total_debe_mt','numeric');
		$this->capturaCount('total_haber_mt','numeric');
		$this->capturaCount('total_debe_ma','numeric');
		$this->capturaCount('total_haber_ma','numeric');
			
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta','int4');
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_debe_mt','numeric');	
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('codigo_cuenta','varchar');
		$this->captura('tipo_cuenta','varchar');
		$this->captura('descripcion_cuenta','varchar');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}



			
}
?>