<?php
/**
*@package pXP
*@file gen-MODGastoSigep.php
*@author  (gsarmiento)
*@date 08-05-2017 20:06:08
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODGastoSigep extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarGastoSigep(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_gasto_sigep_sel';
		$this->transaccion='CONTA_GTSG_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_gasto_sigep','int4');
		$this->captura('programa','int4');
		$this->captura('gestion','int4');
		$this->captura('actividad','int4');
		$this->captura('nro_preventivo','int4');
		$this->captura('nro_comprometido','int4');
		$this->captura('nro_devengado','int4');
		$this->captura('proyecto','int4');
		$this->captura('organismo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('estado','varchar');
		$this->captura('descripcion_gasto','varchar');
		$this->captura('entidad_transferencia','varchar');
		$this->captura('fuente','int4');
		$this->captura('objeto','varchar');
		$this->captura('monto','numeric');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarGastoSigep(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_gasto_sigep_ime';
		$this->transaccion='CONTA_GTSG_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('programa','programa','int4');
		$this->setParametro('gestion','gestion','int4');
		$this->setParametro('actividad','actividad','int4');
		$this->setParametro('nro_preventivo','nro_preventivo','int4');
		$this->setParametro('nro_comprometido','nro_comprometido','int4');
		$this->setParametro('nro_devengado','nro_devengado','int4');
		$this->setParametro('proyecto','proyecto','int4');
		$this->setParametro('organismo','organismo','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('descripcion_gasto','descripcion_gasto','varchar');
		$this->setParametro('entidad_transferencia','entidad_transferencia','varchar');
		$this->setParametro('fuente','fuente','int4');
		$this->setParametro('objeto','objeto','varchar');
		$this->setParametro('monto','monto','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarGastoSigep(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_gasto_sigep_ime';
		$this->transaccion='CONTA_GTSG_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_gasto_sigep','id_gasto_sigep','int4');
		$this->setParametro('programa','programa','int4');
		$this->setParametro('gestion','gestion','int4');
		$this->setParametro('actividad','actividad','int4');
		$this->setParametro('nro_preventivo','nro_preventivo','int4');
		$this->setParametro('nro_comprometido','nro_comprometido','int4');
		$this->setParametro('nro_devengado','nro_devengado','int4');
		$this->setParametro('proyecto','proyecto','int4');
		$this->setParametro('organismo','organismo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('descripcion_gasto','descripcion_gasto','varchar');
		$this->setParametro('entidad_transferencia','entidad_transferencia','varchar');
		$this->setParametro('fuente','fuente','int4');
		$this->setParametro('objeto','objeto','varchar');
		$this->setParametro('monto','monto','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarGastoSigep(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_gasto_sigep_ime';
		$this->transaccion='CONTA_GTSG_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_gasto_sigep','id_gasto_sigep','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>