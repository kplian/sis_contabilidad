<?php
/**
*@package pXP
*@file MODAuxiliar.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 20:44:52
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODAuxiliar extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarAuxiliar(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.f_auxiliar_sel';
		$this->transaccion='CONTA_AUXCTA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		
		$this->setParametro('id_cuenta','id_cuenta','int4');	
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		
		
		//Definicion de la lista del resultado del query
		$this->captura('id_auxiliar','int4');
		$this->captura('id_empresa','int4');
		$this->captura('nombre','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo_auxiliar','varchar');
		$this->captura('nombre_auxiliar','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('corriente','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarAuxiliar(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_auxiliar_ime';
		$this->transaccion='CONTA_AUXCTA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_empresa','id_empresa','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_auxiliar','codigo_auxiliar','varchar');
		$this->setParametro('nombre_auxiliar','nombre_auxiliar','varchar');
		$this->setParametro('corriente','corriente','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarAuxiliar(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_auxiliar_ime';
		$this->transaccion='CONTA_AUXCTA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_empresa','id_empresa','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_auxiliar','codigo_auxiliar','varchar');
		$this->setParametro('nombre_auxiliar','nombre_auxiliar','varchar');
		$this->setParametro('corriente','corriente','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarAuxiliar(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_auxiliar_ime';
		$this->transaccion='CONTA_AUXCTA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_auxiliar','id_auxiliar','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function validarAuxiliar(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.f_auxiliar_ime';
        $this->transaccion='CONTA_COD_AUX_VAL';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('codigo_auxiliar','codigo_auxiliar','varchar');
        $this->setParametro('nombre_auxiliar','nombre_auxiliar','varchar');
        $this->setParametro('corriente','corriente','varchar');

        $this->captura('v_valid','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	//
	function getAuxiliar(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_auxiliar_ime';
		$this->transaccion='CONTA_COD_AUX_GET';
		$this->tipo_procedimiento='IME';	
		//Define los parametros para la funcion
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>