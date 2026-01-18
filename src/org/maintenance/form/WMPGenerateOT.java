/**
 * Licensed under the KARMA v.1 Law of Sharing. As others have shared freely to you, so shall you share freely back to us.
 * If you shall try to cheat and find a loophole in this license, then KARMA will exact your share.
 * and your worldly gain shall come to naught and those who share shall gain eventually above you.
 * In compliance with previous GPLv2.0 works of ComPiere USA, OFBConsulting CHILE, Redhuan D. Oon (www.red1.org) and other contributors 
 * THIS ASSET MAINTENANCE module is contribution of Ramiro Vergara, OFB Consulting, CHILE.
*/
package org.maintenance.form;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;

import org.adempiere.webui.component.Button;
import org.adempiere.webui.component.Checkbox;
import org.adempiere.webui.component.Grid;
import org.adempiere.webui.component.GridFactory;
import org.adempiere.webui.component.Label;
import org.adempiere.webui.component.ListModelTable;
import org.adempiere.webui.component.ListboxFactory;
import org.adempiere.webui.component.Panel;
import org.adempiere.webui.component.Row;
import org.adempiere.webui.component.Rows;
import org.adempiere.webui.component.WListbox;
import org.adempiere.webui.editor.WDateEditor;
import org.adempiere.webui.editor.WSearchEditor;
import org.adempiere.webui.event.ValueChangeEvent;
import org.adempiere.webui.event.ValueChangeListener;
import org.adempiere.webui.event.WTableModelEvent;
import org.adempiere.webui.event.WTableModelListener;
import org.adempiere.webui.panel.ADForm;
import org.adempiere.webui.panel.CustomForm;
import org.adempiere.webui.panel.IFormController;
import org.adempiere.webui.panel.StatusBarPanel;
import org.compiere.model.MColumn;
import org.compiere.model.MDocType;
import org.compiere.model.MLookup;
import org.compiere.model.MLookupFactory;
import org.maintenance.component.MMPMaintain;
import org.maintenance.component.MMPOT;
import org.maintenance.component.MMPOTResource;
import org.maintenance.component.MMPOTTask;
import org.compiere.util.CLogger;
import org.compiere.util.DB;
import org.compiere.util.DisplayType;
import org.compiere.util.Env;
import org.compiere.util.KeyNamePair;
import org.compiere.util.Msg;
import org.compiere.util.Util;
import org.zkoss.zk.ui.event.Event;
import org.zkoss.zk.ui.event.EventListener;
import org.zkoss.zul.Borderlayout;
import org.zkoss.zul.Center;
import org.zkoss.zul.North;
import org.zkoss.zul.Separator;
import org.zkoss.zul.South;

/**
 * Pronostico Mantencion 
 *
 * @author  Fabian Aguilar
 * @version $Id: VMPGenerateOT.java,v 1.2 2010/03/10 00:51:28$
 * 
 * Contributor : Fabian Aguilar - OFBConsulting - generate OT
 */
public class WMPGenerateOT
	implements IFormController, EventListener, WTableModelListener, ValueChangeListener
{
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5322824600164192235L;
	
	private CustomForm form = new CustomForm();

	/**
	 *	Initialize Panel
	 *  @param WindowNo window
	 *  @param frame frame
	 */
	public WMPGenerateOT()
	{
		Env.setContext(Env.getCtx(), m_WindowNo, "IsSOTrx", "Y");   //  defaults to no
		m_C_Currency_ID = Env.getContextAsInt(Env.getCtx(), "$C_Currency_ID");   //  default
		//
		log.info("Currency=" + m_C_Currency_ID);
		try
		{
			dynInit();
			zkInit();
			southPanel.appendChild(new Separator());
			southPanel.appendChild(statusBar);
			
		}
		catch(Exception e)
		{
			log.log(Level.SEVERE, "", e);
		}
	}	//	init

	/**	Window No			*/
	private int         m_WindowNo = 0;
	
	/**	Logger			*/
	private static CLogger log = CLogger.getCLogger(WMPGenerateOT.class);

	
	private boolean     m_calculating = false;
	private int         m_C_Currency_ID = 0;
	
	private Panel parameterPanel = new Panel();
	private Grid parameterLayout = GridFactory.newGridLayout();
	private Borderlayout mainLayout = new Borderlayout();
	private Panel allocationPanel = new Panel();
	private WListbox selectedTable =  ListboxFactory.newDataTable();
	private WListbox prognosisTable =  ListboxFactory.newDataTable();
	private Panel infoPanel = new Panel();
	private int         m_A_Asset_ID = 0;

	
	private Panel prognosisPanel = new Panel();
	private Panel selectedPanel = new Panel();
	private Label prognosisLabel = new Label();
	private Label selectedLabel = new Label();
	private Borderlayout prognosisLayout = new Borderlayout();
	private Borderlayout selectedLayout = new Borderlayout();
	private Label prognosisInfo = new Label();
	private Label invoiceInfo = new Label();
	private Grid allocationLayout = GridFactory.newGridLayout();
	private Button ProcessButton = new Button();
	private Button searchButton = new Button();
	private Button addButton = new Button();
	private Button EnableButton = new Button();
	private Button ChangeButton = new Button();
	private Label assetLabel = new Label();
	private Checkbox selectall = new Checkbox();
	private Label allocCurrencyLabel = new Label();
	private StatusBarPanel statusBar = new StatusBarPanel();
	private Label dateLabel = new Label();
	private WDateEditor dateField = new WDateEditor();
	private WSearchEditor assetSearch = null;

	private Panel southPanel = new Panel();



	/**
	 *  Static Init
	 *  @throws Exception
	 */
	private void zkInit() throws Exception
	{
		form.appendChild(mainLayout);
		mainLayout.setWidth("99%");
		mainLayout.setHeight("100%");
		
		dateLabel.setText(Msg.getMsg(Env.getCtx(), "Date"));
		
		
		//
		parameterPanel.appendChild(parameterLayout);
		allocationPanel.appendChild(allocationLayout);
		prognosisLabel.setText("List of Mps");
		prognosisPanel.appendChild(prognosisLayout);
		selectedPanel.appendChild(selectedLayout);
		
		invoiceInfo.setText(".");
		
		prognosisInfo.setText(".");
		
		ProcessButton.setLabel(Msg.getMsg(Env.getCtx(), "Generate OT"));
		ProcessButton.addActionListener(this);
		searchButton.setLabel(Msg.getMsg(Env.getCtx(), "Search"));
		searchButton.addActionListener(this);
		addButton.setLabel(Msg.getMsg(Env.getCtx(), "Add to Selection"));
		addButton.addActionListener(this);
		EnableButton.setLabel(Msg.getMsg(Env.getCtx(), "Enable Editing"));
		EnableButton.addActionListener(this);
		ChangeButton.setLabel(Msg.getMsg(Env.getCtx(), "set Date"));
		ChangeButton.addActionListener(this);
		
		assetLabel.setText(Msg.translate(Env.getCtx(), "A_Asset_ID"));
		selectall.setText(Msg.getMsg(Env.getCtx(), "Select All"));
		selectall.addActionListener(this);
		allocCurrencyLabel.setText(".");
		
		North north = new North();
		north.setStyle("border: none");
		mainLayout.appendChild(north);
		north.appendChild(parameterPanel);
		Rows rows = null;
		Row row = null;
		
		parameterLayout.setWidth("800px");
		rows = parameterLayout.newRows();
		row = rows.newRow();
		row.appendChild(dateLabel.rightAlign());
		row.appendChild(dateField.getComponent());
		row.appendChild(ChangeButton);
		row.appendChild(selectall);
		row.appendChild(assetLabel.rightAlign());
		row.appendChild(assetSearch.getComponent());
		
		South south = new South();
		south.setStyle("border: none");
		mainLayout.appendChild(south);
		south.appendChild(southPanel);
		southPanel.appendChild(allocationPanel);
		allocationPanel.appendChild(allocationLayout);
		allocationLayout.setWidth("400px");
		rows = allocationLayout.newRows();
		row = rows.newRow();
		row.appendChild(ProcessButton);
			
		prognosisPanel.appendChild(prognosisLayout);
		prognosisPanel.setWidth("100%");
		prognosisPanel.setHeight("100%");
		prognosisLayout.setWidth("100%");
		prognosisLayout.setHeight("100%");
		prognosisLayout.setStyle("border: none");
		
		north = new North();
		north.setStyle("border: none");
		prognosisLayout.appendChild(north);
		north.appendChild(prognosisLabel);
		south = new South();
		south.setStyle("border: none");
		prognosisLayout.appendChild(south);
		south.appendChild(prognosisInfo.rightAlign());
		Center center = new Center();
		prognosisLayout.appendChild(center);
		center.appendChild(prognosisTable);
		prognosisTable.setWidth("99%");
		prognosisTable.setHeight("99%");
		center.setStyle("border: none");
		
		
		
		//
		center = new Center();
		center.setFlex(true);
		mainLayout.appendChild(center);
		center.appendChild(prognosisPanel);
		
		/*infoPanel.setStyle("border: none");
		infoPanel.setWidth("100%");
		infoPanel.setHeight("100%");
		
		north = new North();
		north.setStyle("border: none");
		north.setHeight("49%");
		infoPanel.appendChild(north);
		north.appendChild(prognosisPanel);
		north.setSplittable(true);*/
		
		
		
	}   //  jbInit

	
	/**
	 *  Dynamic Init (prepare dynamic fields)
	 *  @throws Exception if Lookups cannot be initialized
	 */
	private void dynInit() throws Exception
	{
		
	//  Asset
		int AD_Column_ID = MColumn.getColumn_ID("MP_Maintain","A_Asset_ID");        //  MP_Maintain.A_Asset_ID
		MLookup lookupBP = MLookupFactory.get (Env.getCtx(), m_WindowNo, 0, AD_Column_ID, DisplayType.Search);
		assetSearch = new WSearchEditor("A_Asset_ID", true, false, true, lookupBP);
		assetSearch.addValueChangeListener(this);
	
	//  Date set to Login Date
		dateField.setValue(Env.getContextAsDate(Env.getCtx(), "#Date"));
		//  Translation
		statusBar.setStatusLine("Select the maintenance, change the date predicted or directly generate OT");
		statusBar.setStatusDB("");
		loadMPs();
		

	}   //  dynInit

	/**
	 *  Load Business Partner Info
	 *  - Payments
	 *  - Invoices
	 */
	private void loadMPs ()
	{		
		//log.config("Instance_ID=" +Instance_ID);
		//  Need to have both values
		

		
		
		/********************************
		 *  Load Prognosis table
		 *      1-TrxDate, 2-DocumentNo, (3-Currency, 4-PayAmt,)
		 *      5-ConvAmt, 6-ConvOpen, 7-Allocated
		 */
		List<List<Object>> data = new ArrayList<List<Object>>();
		StringBuffer sql = new StringBuffer("select p.AD_PINSTANCE_ID,p.AD_CLIENT_ID,p.AD_ORG_ID," +
				"p.A_ASSET_ID,p.MP_MAINTAIN_ID,p.DESCRIPTION,p.PROGRAMMINGTYPE,p.CICLO,p.DATETRX," +
				"mp.DOCUMENTNO||'-'||mp.Description as MP_name,a.name as assetname  " +
				" from MP_Prognosis p" +
				" Inner Join MP_MainTain mp on (p.MP_MAINTAIN_ID=mp.MP_MAINTAIN_ID)"+
				" Inner Join A_Asset a on (p.A_ASSET_ID=a.A_ASSET_ID)"+
				" where p.Processed='N' and p.Selected='N' " +
				" order by p.DATETRX asc");
		
		log.config("Prognosis=" + sql.toString());
		try
		{
			PreparedStatement pstmt = DB.prepareStatement(sql.toString(), null);
			//pstmt.setInt(1, Instance_ID);
			
			ResultSet rs = pstmt.executeQuery();
			while (rs.next())
			{
				List<Object> line = new ArrayList<Object>();
				line.add(new Boolean(false));       //  0-Selection
				//line.add(new Boolean(false));       //  1-new date
				line.add(rs.getInt(8));       //  1-Ciclo
				line.add(rs.getTimestamp(9)); //  2-Fecha
				KeyNamePair pp = new KeyNamePair(rs.getInt(4), rs.getString(11));
				line.add(pp);      //  3-Activo
				KeyNamePair pp2 = new KeyNamePair(rs.getInt(5), rs.getString(10));
				line.add(pp2);  //  4-mp
				line.add(rs.getString(7));      //  5-programing type
				line.add(rs.getString(6)); 				//  6-description
				
				//
				data.add(line);
			}
			rs.close();
			pstmt.close();
		}
		catch (SQLException e)
		{
			log.log(Level.SEVERE, sql.toString(), e);
		}
		prognosisTable.clear();
		//  Remove previous listeners
		prognosisTable.getModel().removeTableModelListener(this);
		//  Header Info
		List<String> columnNames = new ArrayList<String>();
		columnNames.add("Generar OT");
		columnNames.add(Msg.getMsg(Env.getCtx(), "Ciclo"));
		columnNames.add(Msg.translate(Env.getCtx(), "Date"));
		columnNames.add(Util.cleanAmp(Msg.translate(Env.getCtx(), "Asset")));
		columnNames.add(Msg.getMsg(Env.getCtx(), "MP"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "Programing Type"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "Description"));

		
		//  Set Model
		ListModelTable modelP = new ListModelTable(data);
		modelP.addTableModelListener(this);
		prognosisTable.setData(modelP, columnNames);
		//
		int i = 0;
		prognosisTable.setColumnClass(i++, Boolean.class, false);         //  0-Selection
		//prognosisTable.setColumnClass(i++, Boolean.class, false);         //  1-new date
		prognosisTable.setColumnClass(i++, Integer.class, true);           //  2-ciclo
		prognosisTable.setColumnClass(i++, Timestamp.class, true);        //  3-TrxDate
		prognosisTable.setColumnClass(i++, String.class, true);       //  4-asset
		prognosisTable.setColumnClass(i++, String.class, true);       //  5-MP
		prognosisTable.setColumnClass(i++, String.class, true);      //  6-programing type
		prognosisTable.setColumnClass(i++, String.class, true);      //  7-Description
		//  Table UI
		prognosisTable.autoSize();
		
		prognosisTable.setColumnReadOnly(1, false);

		calculate();
	}   //  loadBPartner


	
	/**************************************************************************
	 *  Action Listener.
	 *  - MultiCurrency
	 *  - Allocate
	 *  @param e event
	 */
	public void onEvent(Event e)
	{
		log.config("");
		if (e.getTarget().equals(ProcessButton))
		{
			//ProcessButton.setEnabled(false);
			saveData();

			
		}
		else if (e.getTarget().equals(EnableButton))
		{
			prognosisTable.setColumnReadOnly(1, false);
			prognosisTable.setColumnReadOnly(2, false);
			prognosisTable.setColumnReadOnly(3, false);
			/*Object Period = JOptionPane.showInputDialog(
					   this,
					   "Seleccione Periodo",
					   "Selector de opciones",
					   JOptionPane.QUESTION_MESSAGE,
					   null,  // null para icono defecto
					   new Object[] { "1", "2", "3", "4", "5", "6", "7", "8" }, 
					   "1");

			
			String trxName = Trx.createTrxName("IOG");	
			Trx trx = Trx.get(trxName, true);
			AD_Process_ID = DB.getSQLValue(trxName, "select AD_Process_ID from AD_Process where upper(procedurename)='MP_PROGNOSIS_PROCESS'");
			if(instance==null){
				instance = new MPInstance(Env.getCtx(), AD_Process_ID, 0);
				if (!instance.save())
				{
					log.severe("ProcessNoInstance");
					
					return;
				}
			}
			
			//call process
			ProcessInfo pi = new ProcessInfo ("VMPGenerateOT", AD_Process_ID);
			pi.setAD_PInstance_ID (instance.getAD_PInstance_ID());
//			Add Parameter - Selection=Y
			MPInstancePara ip = new MPInstancePara(instance, 10);
			ip.setParameter("PeriodNo",Integer.parseInt((String)Period));
			if (!ip.save())
			{
				String msg = "No Parameter added";  //  not translated
				log.log(Level.SEVERE, msg);
				return;
			}
			
//			Execute Process
			ProcessCtl worker = new ProcessCtl(this, Env.getWindowNo(this), pi, trx);
			worker.start(); 
			
			loadMPs(instance.getAD_PInstance_ID());*/
		}
		/*else if (e.getSource().equals(addButton)){
			ProcessButton.setEnabled(true);
			//updating rows selected
			TableModel prognosis = prognosisTable.getModel();
			int rows = prognosis.getRowCount();
			for (int i = 0; i < rows; i++)
			{
				if (((Boolean)prognosis.getValueAt(i, 0)).booleanValue())
				{
					KeyNamePair pp = (KeyNamePair)prognosis.getValueAt(i, 3);   //  Asset
					int Asset_ID=pp.getKey();
					pp = (KeyNamePair)prognosis.getValueAt(i, 4);   //  MP
					int MP_ID=pp.getKey();
					
					int ciclo=((Integer)prognosis.getValueAt(i, 1)).intValue();   //  Ciclo
					String ProgramingType=(String)prognosis.getValueAt(i, 5);   //  Programing
					
					String sql="Update MP_Prognosis set selected='Y' where ciclo="+ciclo
					+ " and MP_MAINTAIN_ID="+MP_ID+" and A_Asset_ID="+Asset_ID
					+ " and PROGRAMMINGTYPE='"+ ProgramingType +"'";  
					
					DB.executeUpdate(sql);
					
				}
			}

			
			//load rows
			loadMPs(instance.getAD_PInstance_ID());
		}*/
		else if (e.getTarget().equals(ChangeButton)){
			ProcessButton.setEnabled(true);
			//updating rows selected
			
			int rows = prognosisTable.getRowCount();
			Timestamp DateTrx = (Timestamp)dateField.getValue();
			for (int i = 0; i < rows; i++)
			{
				if (((Boolean)prognosisTable.getValueAt(i, 0)).booleanValue())
				{
					
					prognosisTable.setValueAt(DateTrx, i, 2);
					
				}
			}
		}
		else if (e.getTarget().equals(selectall)){
			
			int rows = prognosisTable.getRowCount();
			for (int i = 0; i < rows; i++)
			{		
				if(m_A_Asset_ID==0)
					prognosisTable.setValueAt(selectall.isSelected(), i, 0);
				else{
					KeyNamePair pp = (KeyNamePair)prognosisTable.getValueAt(i, 3);//Asset
					int Asset_ID=pp.getKey();
					if(Asset_ID==m_A_Asset_ID)
						prognosisTable.setValueAt(selectall.isSelected(), i, 0);
				}
				
			}
		}
	}   //  actionPerformed

	/**
	 *  Table Model Listener.
	 *  - Recalculate Totals
	 *  @param e event
	 */
	public void tableChanged(WTableModelEvent e)
	{
		boolean isUpdate = (e.getType() == WTableModelEvent.CONTENTS_CHANGED);
		//  Not a table update
		if (!isUpdate)
		{
			calculate();
			return;
		}
	

		/**
		 *  Setting defaults
		 */
		if (m_calculating)  //  Avoid recursive calls
			return;
		m_calculating = true;
		

		m_calculating = false;
		calculate();
	}   //  tableChanged

	/**
	 *  Calculate Allocation info
	 */
	private void calculate ()
	{
		log.config("");
		//
		
	}   //  calculate

	/**
	 *  Vetoable Change Listener.
	 *  - Business Partner
	 *  - Currency
	 * 	- Date
	 *  @param e event
	 */
	public void valueChange (ValueChangeEvent e)
	{
		String name = e.getPropertyName();
		Object value = e.getNewValue();
		log.config(name + "=" + value);
		if (name.equals("A_Asset_ID"))
		{
			assetSearch.setValue(value);
			if (value != null)
			m_A_Asset_ID = ((Integer)value).intValue();
			
		}
		
	}   //  vetoableChange

	
	/**************************************************************************
	 *  Save Data
	 */
	private void saveData()
	{
		
		ListModelTable prognosis = prognosisTable.getModel();
		int rows = prognosis.getRowCount();
		for (int i = 0; i < rows; i++)
		{
			if (((Boolean)prognosis.getValueAt(i, 0)).booleanValue())
			{
				KeyNamePair pp = (KeyNamePair)prognosis.getValueAt(i, 4);//MP
				int MP_ID=pp.getKey();
				pp = (KeyNamePair)prognosis.getValueAt(i, 3);//Asset
				int Asset_ID=pp.getKey();
				Timestamp Datetrx =(Timestamp)prognosis.getValueAt(i, 2);//Date
				String description =(String)prognosis.getValueAt(i, 6);//Description
				int ciclo=((Integer)prognosis.getValueAt(i, 1)).intValue();   //  Ciclo
				String ProgramingType=(String)prognosis.getValueAt(i, 5);   //  Programing
				
				
				if(!createOT(MP_ID,Datetrx,description,Asset_ID)){
						log.log(Level.SEVERE, "OT not created #" + i);
						continue;
				}
				
				//updating  MP
				updateMP(MP_ID,Datetrx,description);
				
				String sql="Update MP_Prognosis set Processed='Y' where ciclo="+ciclo
				+ " and MP_MAINTAIN_ID="+MP_ID+" and A_Asset_ID="+Asset_ID
				+ " and PROGRAMMINGTYPE='"+ ProgramingType +"'";  
				
				DB.executeUpdate(sql);
				
				
			}
		}
		loadMPs ();
	}   //  saveData
	
	
	public boolean createOT(int MP_ID, Timestamp Datetrx,String description,int Asset_ID ){
		
		//create header OT
		MMPOT newOT=new MMPOT(Env.getCtx(), 0,null);
		newOT.setDateTrx(Datetrx);
		newOT.setDescription(description);
		newOT.setA_Asset_ID(Asset_ID);
		newOT.setMP_Maintain_ID(MP_ID);
		newOT.setDocStatus("DR");
		newOT.setDocAction("CO");
		newOT.setC_DocType_ID(MDocType.getOfDocBaseType(Env.getCtx(), "MOF")[0].getC_DocType_ID());
		if(!newOT.save())//creada nueva OT
			return false;
		
		if(!createOTTaskDetail(MP_ID,newOT))
			return false;
		
		String sql = "select mp_maintain_id from mp_maintain where ischild='Y' and MP_MAINTAINPARENT_ID=?";
		PreparedStatement pstmt = null;
		try
		{
			pstmt = DB.prepareStatement(sql,null);
			pstmt.setInt(1,MP_ID);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()){
				createOTTaskDetail(rs.getInt(1),newOT);
				lookChilds(rs.getInt(1),newOT);
			}
			rs.close();
			pstmt.close();
			pstmt = null;
		}
		catch (Exception e)
		{
			log.log(Level.SEVERE, sql, e);
		}
		
		
		
		return true;
	}
	
	public void lookChilds(int MP_ID, MMPOT OT){
		
		String sql = "select mp_maintain_id from mp_maintain where ischild='Y' and MP_MAINTAINPARENT_ID=?";
		PreparedStatement pstmt = null;
		try
		{
			pstmt = DB.prepareStatement(sql,null);
			pstmt.setInt(1,MP_ID);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()){
				createOTTaskDetail(rs.getInt(1),OT);
				lookChilds(rs.getInt(1),OT);
			}
			rs.close();
			pstmt.close();
			pstmt = null;
		}
		catch (Exception e)
		{
			log.log(Level.SEVERE, sql, e);
		}
		
	}
	
	public boolean createOTTaskDetail(int MP_ID, MMPOT OT){
		String sql = "select * from MP_MAINTAIN_TASK where MP_MAINTAIN_ID=?";
		PreparedStatement pstmt = null;
		try
		{
			pstmt = DB.prepareStatement(sql,null);
			pstmt.setInt(1,MP_ID);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()){
				MMPOTTask ta = new MMPOTTask(Env.getCtx(), 0,null);
				ta.setMP_Maintain_ID(MP_ID);
				ta.setAD_Org_ID(rs.getInt("AD_Org_ID"));
				ta.setMP_OT_ID(OT.getMP_OT_ID());
				ta.setDescription(rs.getString("Description"));
				ta.setDuration(rs.getBigDecimal("Duration"));
				ta.setC_UOM_ID(rs.getInt("C_UOM_ID"));
				ta.setStatus(ta.STATUS_NotStarted);
				ta.saveEx();
				
				createOTResourceDetail(rs.getInt("MP_MAINTAIN_TASK_ID"),ta.getMP_OT_Task_ID());
			}
			rs.close();
			pstmt.close();
			pstmt = null;
		}
		catch (Exception e)
		{
			log.log(Level.SEVERE, sql, e);
		}
		
		//update MP
		updateMP(MP_ID,OT.getDateTrx(),OT.getDescription());
		
		return true;
		
	}
	public boolean createOTResourceDetail(int oldTask_ID, int newTask_ID){
		
		String sql = "select * from MP_MAINTAIN_RESOURCE where MP_MAINTAIN_TASK_ID=?";
		PreparedStatement pstmt = null;
		try
		{
			pstmt = DB.prepareStatement(sql,null);
			pstmt.setInt(1,oldTask_ID);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()){
				MMPOTResource re=new MMPOTResource(Env.getCtx(), 0,null);
				re.setAD_Org_ID(rs.getInt("AD_Org_ID"));
				re.setMP_OT_Task_ID(newTask_ID);
				re.setCostAmt(rs.getBigDecimal("CostAmt"));
				re.setS_Resource_ID(rs.getInt("S_Resource_ID"));
				re.setM_BOM_ID(rs.getInt("M_BOM_ID"));
				re.setResourceQty(rs.getBigDecimal("RESOURCEQTY"));
				re.setResourceType(rs.getString("RESOURCETYPE"));
				re.set_ValueOfColumn("M_Product_ID", rs.getInt("M_Product_ID"));
				re.saveEx();
			}
			rs.close();
			pstmt.close();
			pstmt = null;
		}
		catch (Exception e)
		{
			log.log(Level.SEVERE, sql, e);
		}
		
		return true;
		
	}
	
	public void updateMP(int MP_ID,Timestamp Datetrx,String description ){
		MMPMaintain mp= new MMPMaintain(Env.getCtx(), MP_ID,null);
		mp.setdatelastrunmp(Datetrx);
		mp.setDateLastRun(Datetrx);
		if(mp.getProgrammingType().equals("C"))
			mp.setDateNextRun(new Timestamp(Datetrx.getTime()+(mp.getInterval().longValue()*86400000) ));
		else{
			mp.setnextmp(mp.getInterval().add(mp.getlastmp()).setScale(2, BigDecimal.ROUND_HALF_EVEN));
			mp.setlastmp(new BigDecimal(Float.parseFloat(description.split(":")[description.split(":").length-1].replace(',', '.'))).setScale(2, BigDecimal.ROUND_HALF_EVEN));
		}
		mp.save(); //actualizacion MP
	}
	


	
	/**
	 * Called by org.adempiere.webui.panel.ADForm.openForm(int)
	 * @return
	 */
	public ADForm getForm()
	{
		return form;
	}
	
	

}   //  VAllocation
