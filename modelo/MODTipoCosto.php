<?php
/**
*@package pXP
*@file gen-MODTipoCosto.php
*@author  (admin)
*@date 27-12-2016 20:53:14
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoCosto extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoCosto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cos.ft_tipo_costo_sel';
		$this->transaccion='COS_TCO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_costo','int4');
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
		$this->captura('sw_trans','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('id_tipo_costo_fk','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
       // var_dump($this->respuesta); exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}


function listarTipoCostoArb(){
		    //Definicion de variables para ejecucion del procedimientp
		    $this->procedimiento='cos.ft_tipo_costo_sel';
		    $this-> setCount(false);
		    $this->transaccion='COS_TICOSARB_SEL';
		    $this->tipo_procedimiento='SEL';//tipo de transaccion
		    
		    $id_padre = $this->objParam->getParametro('id_padre');
		    
		    $this->setParametro('id_padre','id_padre','varchar');
		    $this->setParametro('id_gestion','id_gestion','int4');
            $this->captura('id_tipo_costo','int4');
			$this->captura('codigo','varchar');
			$this->captura('nombre','varchar');
			$this->captura('sw_trans','varchar');
			$this->captura('descripcion','varchar');
			$this->captura('id_tipo_costo_fk','int4');
			$this->captura('estado_reg','varchar');
			$this->captura('id_usuario_ai','int4');
			$this->captura('usuario_ai','varchar');
			$this->captura('fecha_reg','timestamp');
			$this->captura('id_usuario_reg','int4');
			$this->captura('id_usuario_mod','int4');
			$this->captura('fecha_mod','timestamp');
			$this->captura('usr_reg','varchar');
			$this->captura('usr_mod','varchar');
			$this->captura('tipo_nodo','varchar');
            $this->captura('id_gestion','int4');
           

		     //Ejecuta la instruccion
		     $this->armarConsulta();
			 $this->ejecutarConsulta();


		    return $this->respuesta;       
    }
			
			
	function insertarTipoCosto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cos.ft_tipo_costo_ime';
		$this->transaccion='COS_TCO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('sw_trans','sw_trans','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('id_tipo_costo_fk','id_tipo_costo_fk','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoCosto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cos.ft_tipo_costo_ime';
		$this->transaccion='COS_TCO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_costo','id_tipo_costo','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('sw_trans','sw_trans','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('id_tipo_costo_fk','id_tipo_costo_fk','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoCosto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cos.ft_tipo_costo_ime';
		$this->transaccion='COS_TCO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_costo','id_tipo_costo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>