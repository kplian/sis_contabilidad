<?php
/**
*@package pXP
*@file ACTCuenta.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 15:04:03
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCuenta extends ACTbase{    
			
	function listarCuenta(){
		$this->objParam->defecto('ordenacion','id_cuenta');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("cta.id_gestion = ".$this->objParam->getParametro('id_gestion'));    
        }
        
        
        if($this->objParam->getParametro('sw_transaccional')!=''){
            $this->objParam->addFiltro("cta.sw_transaccional = ''".$this->objParam->getParametro('sw_transaccional')."''"); 
        }
        
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuenta','listarCuenta');
		} else{
			$this->objFunc=$this->create('MODCuenta');
			
			$this->res=$this->objFunc->listarCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarCuentaArb(){
        
        //obtiene el parametro nodo enviado por la vista
        $node=$this->objParam->getParametro('node');

        $id_cuenta=$this->objParam->getParametro('id_cuenta');
        $tipo_nodo=$this->objParam->getParametro('tipo_nodo');
        
                   
        if($node=='id'){
            $this->objParam->addParametro('id_padre','%');
        }
        else {
            $this->objParam->addParametro('id_padre',$id_cuenta);
        }
        
								$this->objFunc=$this->create('MODCuenta');
        $this->res=$this->objFunc->listarCuentaArb();
        
        $this->res->setTipoRespuestaArbol();
        
        $arreglo=array();
        
        array_push($arreglo,array('nombre'=>'id','valor'=>'id_cuenta'));
        array_push($arreglo,array('nombre'=>'id_p','valor'=>'id_cuenta_padre'));
        
        
        array_push($arreglo,array('nombre'=>'text','valores'=>'<b> #nro_cuenta# - #nombre_cuenta#</b>'));
        array_push($arreglo,array('nombre'=>'cls','valor'=>'nombre_cuenta'));
        array_push($arreglo,array('nombre'=>'qtip','valores'=>'<b> #nro_cuenta#</b><br/><b> #nombre_cuenta#</b><br> #desc_cuenta#'));
        
        
        $this->res->addNivelArbol('tipo_nodo','raiz',array('leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'cls'=>'folder',
                                                        'tipo_nodo'=>'raiz',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);
         
        /*se ande un nivel al arbol incluyendo con tido de nivel carpeta con su arreglo de equivalencias
          es importante que entre los resultados devueltos por la base exista la variable\
          tipo_dato que tenga el valor en texto = 'hoja' */
                                                                

         $this->res->addNivelArbol('tipo_nodo','hijo',array(
                                                        'leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hijo',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);
														
		
		$this->res->addNivelArbol('tipo_nodo','hoja',array(
                                                        'leaf'=>true,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hoja',
                                                        'icon'=>'../../../lib/imagenes/a_table_gear.png'),
                                                        $arreglo);												
														

        $this->res->imprimirRespuesta($this->res->generarJson());         

 }
				
	function insertarCuenta(){
		$this->objFunc=$this->create('MODCuenta');	
		if($this->objParam->insertar('id_cuenta')){
			$this->res=$this->objFunc->insertarCuenta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCuenta(){
			$this->objFunc=$this->create('MODCuenta');	
		$this->res=$this->objFunc->eliminarCuenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>