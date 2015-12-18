<?php
/**
*@package pXP
*@file gen-MODAjusteDet.php
*@author  (admin)
*@date 10-12-2015 15:16:44
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODAjusteDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarAjusteDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_ajuste_det_sel';
		$this->transaccion='CONTA_AJTD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_ajuste_det','int4');
		$this->captura('mayor_mb','numeric');
		$this->captura('tipo_cambio_1','numeric');
		$this->captura('tipo_cambio_2','numeric');
		$this->captura('mayor','numeric');
		$this->captura('mayor_mt','numeric');
		$this->captura('dif_mb','numeric');
		$this->captura('act_mb','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_ajuste','int4');
		$this->captura('dif_mt','numeric');
		$this->captura('act_mt','numeric');
		$this->captura('id_cuenta','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('nro_cuenta','varchar');
		$this->captura('nombre_cuenta','varchar');
		$this->captura('id_moneda_cuenta','int4');
		$this->captura('codigo_moneda','varchar');
		$this->captura('revisado','varchar');
		
		$this->captura('dif_manual','varchar');
		
		$this->captura('desc_auxiliar','text');
		$this->captura('desc_cuenta_bancaria','text');
		$this->captura('desc_partida_ingreso','text');
		$this->captura('desc_partida_egreso','text');
		
		
		$this->captura('id_moneda_ajuste','integer');
		
		
		
		
		
		
		
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarAjusteDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_ajuste_det_ime';
		$this->transaccion='CONTA_AJTD_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('mayor_mb','mayor_mb','numeric');
		$this->setParametro('tipo_cambio_1','tipo_cambio_1','numeric');
		$this->setParametro('tipo_cambio_2','tipo_cambio_2','numeric');
		$this->setParametro('mayor','mayor','numeric');
		$this->setParametro('mayor_mt','mayor_mt','numeric');
		$this->setParametro('dif_mb','dif_mb','numeric');
		$this->setParametro('act_mb','act_mb','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_ajuste','id_ajuste','int4');
		$this->setParametro('dif_mt','dif_mt','numeric');
		$this->setParametro('act_mt','act_mt','numeric');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_partida_ingreso','id_partida_ingreso','int4');
		$this->setParametro('id_partida_egreso','id_partida_egreso','int4');
		
		$this->setParametro('id_moneda_ajuste','id_moneda_ajuste','integer');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarAjusteDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_ajuste_det_ime';
		$this->transaccion='CONTA_AJTD_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_ajuste_det','id_ajuste_det','int4');
		$this->setParametro('mayor_mb','mayor_mb','numeric');
		$this->setParametro('tipo_cambio_1','tipo_cambio_1','numeric');
		$this->setParametro('tipo_cambio_2','tipo_cambio_2','numeric');
		$this->setParametro('mayor','mayor','numeric');
		$this->setParametro('mayor_mt','mayor_mt','numeric');
		$this->setParametro('dif_mb','dif_mb','numeric');
		$this->setParametro('act_mb','act_mb','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_ajuste','id_ajuste','int4');
		$this->setParametro('dif_mt','dif_mt','numeric');
		$this->setParametro('act_mt','act_mt','numeric');
		$this->setParametro('id_cuenta','id_cuenta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarAjusteDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_ajuste_det_ime';
		$this->transaccion='CONTA_AJTD_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_ajuste_det','id_ajuste_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function cambiarRevision(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_ajuste_det_ime';
		$this->transaccion='CONTA_REVAJ_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_ajuste_det','id_ajuste_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
			
}
?>