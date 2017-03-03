<?php
/**
*@package pXP
*@file gen-MODTipoCostoCuenta.php
*@author  (admin)
*@date 30-12-2016 20:29:17
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoCostoCuenta extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoCostoCuenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cos.ft_tipo_costo_cuenta_sel';
		$this->transaccion='COS_COC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_costo_cuenta','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo_cuenta','varchar');
		$this->captura('id_auxiliares','varchar');
		$this->captura('auxiliares','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_tipo_costo','int4');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//var_dump($this->respuesta); exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoCostoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cos.ft_tipo_costo_cuenta_ime';
		$this->transaccion='COS_COC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_cuenta','codigo_cuenta','varchar');
		$this->setParametro('id_auxiliares','id_auxiliares','varchar');
		$this->setParametro('id_tipo_costo','id_tipo_costo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoCostoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cos.ft_tipo_costo_cuenta_ime';
		$this->transaccion='COS_COC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_costo_cuenta','id_tipo_costo_cuenta','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_cuenta','codigo_cuenta','varchar');
		$this->setParametro('id_auxiliares','id_auxiliares','varchar');
		$this->setParametro('id_tipo_costo','id_tipo_costo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoCostoCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cos.ft_tipo_costo_cuenta_ime';
		$this->transaccion='COS_COC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_costo_cuenta','id_tipo_costo_cuenta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	function listarCuentas(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cos.ft_tipo_costo_cuenta_sel';
        $this->transaccion='COS_CUEN_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_cuenta','int4');
        $this->captura('nro_cuenta','varchar');
        $this->captura('nombre_cuenta','varchar');
        $this->captura('desc_cuenta','varchar');
        $this->captura('nivel_cuenta','int4');
        $this->captura('tipo_cuenta','varchar');
        $this->captura('sw_transaccional','varchar');
        $this->captura('sw_auxiliar','varchar');
        $this->captura('tipo_cuenta_pat','varchar');
        $this->captura('desc_moneda','varchar');
        $this->captura('gestion','int4');
        $this->captura('sw_control_efectivo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta); exit;
        //Devuelve la respuesta
        return $this->respuesta;

    }

}
?>