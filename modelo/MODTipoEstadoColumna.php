<?php
/**
*@package pXP
*@file gen-MODTipoEstadoColumna.php
*@author  (admin)
*@date 26-07-2017 21:49:56
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoEstadoColumna extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoEstadoColumna(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_tipo_estado_columna_sel';
		$this->transaccion='CONTA_TECC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_estado_columna','int4');
		$this->captura('codigo','varchar');
		$this->captura('link_int_det','varchar');
		$this->captura('origen','varchar');
		$this->captura('id_config_subtipo_cuenta','int4');
		$this->captura('nombre','varchar');
		$this->captura('nombre_funcion','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('prioridad','numeric');
		$this->captura('id_tipo_estado_cuenta','int4');
		$this->captura('desc_csc','varchar');
		
		$this->captura('descripcion','varchar');
		$this->captura('nombre_clase','varchar');
		$this->captura('parametros_det ','varchar');
		
		
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoEstadoColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_estado_columna_ime';
		$this->transaccion='CONTA_TECC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('link_int_det','link_int_det','varchar');
		$this->setParametro('origen','origen','varchar');
		$this->setParametro('id_config_subtipo_cuenta','id_config_subtipo_cuenta','int4');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('nombre_funcion','nombre_funcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('prioridad','prioridad','numeric');
		$this->setParametro('id_tipo_estado_cuenta','id_tipo_estado_cuenta','int4');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('nombre_clase','nombre_clase','varchar');
		$this->setParametro('parametros_det','parametros_det','varchar');
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoEstadoColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_estado_columna_ime';
		$this->transaccion='CONTA_TECC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_estado_columna','id_tipo_estado_columna','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('link_int_det','link_int_det','varchar');
		$this->setParametro('origen','origen','varchar');
		$this->setParametro('id_config_subtipo_cuenta','id_config_subtipo_cuenta','int4');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('nombre_funcion','nombre_funcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('prioridad','prioridad','numeric');
		$this->setParametro('id_tipo_estado_cuenta','id_tipo_estado_cuenta','int4');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('nombre_clase','nombre_clase','varchar');
		$this->setParametro('parametros_det','parametros_det','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoEstadoColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_estado_columna_ime';
		$this->transaccion='CONTA_TECC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_estado_columna','id_tipo_estado_columna','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>