<font size="9">
<?php   
	if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		$with_col = '60%';
	}
	else{
		$with_col = '50%';
	}

?>
<table width="100%" cellpadding="5px"  rules="cols" border="1">
	<tbody>
	
		
 <tr>		
		<td width="100%" class="td_label" align="right"><font size="7"><?php  echo $this->cabecera[0]['usr_reg']; ?>  (id: <?php  echo $this->cabecera[0]['id_int_comprobante']; ?>)</font></td>	
       </tr>
		
    </tbody>
 </table>

</font>		