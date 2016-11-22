<?php
/**
*@package pXP
*@file gen-MODEntrega.php
*@author  (admin)
*@date 17-11-2016 19:50:19
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODEntrega extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarEntrega(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_entrega_sel';
		$this->transaccion='CONTA_ENT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_entrega','int4');
		$this->captura('fecha_c31','date');
		$this->captura('c31','varchar');
		$this->captura('estado','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_depto_conta','int4');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarEntrega(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_ime';
		$this->transaccion='CONTA_ENT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('fecha_c31','fecha_c31','date');
		$this->setParametro('c31','c31','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarEntrega(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_ime';
		$this->transaccion='CONTA_ENT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_entrega','id_entrega','int4');
		$this->setParametro('fecha_c31','fecha_c31','date');
		$this->setParametro('c31','c31','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarEntrega(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_ime';
		$this->transaccion='CONTA_ENT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_entrega','id_entrega','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function crearEntrega(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_ime';
		$this->transaccion='CONTA_CRENT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobantes','id_int_comprobantes','varchar');
		$this->setParametro('total_cbte','total_cbte','int4');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	 function cambiarEstado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_ime';
		$this->transaccion='CONTA_FINENTR_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_entrega','id_entrega','int4');
		$this->setParametro('c31','c31','varchar');
		$this->setParametro('fecha_c31','fecha_c31','date');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('id_tipo_relacion_comprobante','id_tipo_relacion_comprobante','int4');
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
			
}
?>