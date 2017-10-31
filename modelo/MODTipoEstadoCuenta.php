<?php
/**
*@package pXP
*@file gen-MODTipoEstadoCuenta.php
*@author  (admin)
*@date 26-07-2017 21:48:36
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoEstadoCuenta extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarTipoEstadoCuenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_tipo_estado_cuenta_sel';
		$this->transaccion='CONTA_TEC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_estado_cuenta','int4');
		$this->captura('codigo','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('columna_codigo_aux','varchar');
		$this->captura('columna_id_tabla','varchar');
		$this->captura('tabla','varchar');
		$this->captura('nombre','varchar');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarEstadoCuenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.f_estado_cuenta';
		$this->transaccion='CONTA_ESTCUNT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this-> setCount(false);
		$this->setTipoRetorno('record');
		
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_tipo_estado_cuenta','id_tipo_estado_cuenta','int4');
		$this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
		
		
		$this->captura('id_auxiliar','int4');
        $this->captura('id_tipo_estado_cuenta','int4');
        $this->captura('id_tipo_estado_columna','int4');
        $this->captura('id_config_subtipo_cuenta','int4');
        $this->captura('fecha_ini','date');
        $this->captura('fecha_fin','date');
        $this->captura('desc_csc','varchar');
        $this->captura('codigo','varchar');
        $this->captura('nombre','varchar');
        $this->captura('monto_mb','numeric');
        $this->captura('monto_mt','numeric');
        $this->captura('prioridad','numeric');
        $this->captura('nombre_funcion','varchar');
        $this->captura('link_int_det','varchar');
        $this->captura('tabla','varchar');
        $this->captura('id_tabla','int4');
        $this->captura('origen','varchar');
        $this->captura('descripcion','varchar');
		$this->captura('desc_auxiliar','varchar');
		$this->captura('nombre_clase','varchar');
		$this->captura('parametros_det','varchar');
		
				
		
		
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}



			
	function insertarTipoEstadoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_estado_cuenta_ime';
		$this->transaccion='CONTA_TEC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('columna_codigo_aux','columna_codigo_aux','varchar');
		$this->setParametro('columna_id_tabla','columna_id_tabla','varchar');
		$this->setParametro('tabla','tabla','varchar');
		$this->setParametro('nombre','nombre','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoEstadoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_estado_cuenta_ime';
		$this->transaccion='CONTA_TEC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_estado_cuenta','id_tipo_estado_cuenta','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('columna_codigo_aux','columna_codigo_aux','varchar');
		$this->setParametro('columna_id_tabla','columna_id_tabla','varchar');
		$this->setParametro('tabla','tabla','varchar');
		$this->setParametro('nombre','nombre','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoEstadoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_estado_cuenta_ime';
		$this->transaccion='CONTA_TEC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_estado_cuenta','id_tipo_estado_cuenta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	//**************//
	function listarDatos(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_tipo_estado_cuenta_sel';
		$this->transaccion='CONTA_REP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);	
				
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_tipo_estado_cuenta','id_tipo_estado_cuenta','int4');
		$this->setParametro('desde','desde','DATE');
		$this->setParametro('hasta','hasta','DATE');

		$this->captura('id_auxiliar','int4');
        $this->captura('id_tipo_estado_cuenta','int4');
        $this->captura('id_tipo_estado_columna','int4');
        $this->captura('id_config_subtipo_cuenta','int4');
        $this->captura('fecha_ini','date');
        $this->captura('fecha_fin','date');
        $this->captura('desc_csc','varchar');
        $this->captura('codigo','varchar');
        $this->captura('nombre','varchar');
        $this->captura('monto_mb','numeric');
        $this->captura('monto_mt','numeric');
        $this->captura('prioridad','numeric');
        $this->captura('nombre_funcion','varchar');
        $this->captura('link_int_det','varchar');
        $this->captura('tabla','varchar');
        $this->captura('id_tabla','int4');
        $this->captura('origen','varchar');
        $this->captura('descripcion','varchar');
		$this->captura('desc_auxiliar','varchar');
		$this->captura('nombre_clase','varchar');
		$this->captura('parametros_det','varchar');
	
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}	
	//
	function getTipoEstadoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_estado_cuenta_ime';
		$this->transaccion='CONTA_TEC_GET';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_estado_cuenta','id_tipo_estado_cuenta','int4');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}	
			
}
?>