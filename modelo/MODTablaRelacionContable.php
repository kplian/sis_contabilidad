<?php
/**
*@package pXP
*@file gen-MODTablaRelacionContable.php
*@author  (admin)
*@date 16-05-2013 21:05:26
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTablaRelacionContable extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTablaRelacionContable(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_tabla_relacion_contable_sel';
		$this->transaccion='CONTA_TABRECON_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tabla_relacion_contable','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('tabla','varchar');
		$this->captura('esquema','varchar');
		$this->captura('tabla_id','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('tabla_id_fk','varchar');
		$this->captura('recorrido_arbol','varchar');
		$this->captura('tabla_codigo_auxiliar','varchar');
		$this->captura('tabla_id_auxiliar','varchar');
		
		$this->captura('tabla_codigo_aplicacion','varchar');
		
		
		
		  
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTablaRelacionContable(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tabla_relacion_contable_ime';
		$this->transaccion='CONTA_TABRECON_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tabla','tabla','varchar');
		$this->setParametro('esquema','esquema','varchar');
		$this->setParametro('tabla_id','tabla_id','varchar');
		$this->setParametro('tabla_id_fk','tabla_id_fk','varchar');
		$this->setParametro('recorrido_arbol','recorrido_arbol','varchar');
		$this->setParametro('tabla_codigo_auxiliar','tabla_codigo_auxiliar','varchar');
		$this->setParametro('tabla_id_auxiliar','tabla_id_auxiliar','varchar');
		$this->setParametro('tabla_codigo_aplicacion','tabla_codigo_aplicacion','varchar');
		
		
            

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTablaRelacionContable(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tabla_relacion_contable_ime';
		$this->transaccion='CONTA_TABRECON_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tabla_relacion_contable','id_tabla_relacion_contable','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tabla','tabla','varchar');
		$this->setParametro('esquema','esquema','varchar');
		$this->setParametro('tabla_id','tabla_id','varchar');
		$this->setParametro('tabla_id_fk','tabla_id_fk','varchar');
		$this->setParametro('recorrido_arbol','recorrido_arbol','varchar');
		$this->setParametro('tabla_codigo_auxiliar','tabla_codigo_auxiliar','varchar');
        $this->setParametro('tabla_id_auxiliar','tabla_id_auxiliar','varchar');		
		$this->setParametro('tabla_codigo_aplicacion','tabla_codigo_aplicacion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTablaRelacionContable(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tabla_relacion_contable_ime';
		$this->transaccion='CONTA_TABRECON_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tabla_relacion_contable','id_tabla_relacion_contable','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>