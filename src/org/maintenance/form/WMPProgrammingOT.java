/**
 * Licensed under the KARMA v.1 Law of Sharing. As others have shared freely to you, so shall you share freely back to us.
 * If you shall try to cheat and find a loophole in this license, then KARMA will exact your share.
 * and your worldly gain shall come to naught and those who share shall gain eventually above you.
 * In compliance with previous GPLv2.0 works of ComPiere USA, Ramiro Vergara, OFB Consulting, CHILE. 
 * Enhanced by Redhuan D. Oon (red1org@gmail.com). sponsored by Zeeshan@sysnova.com
*/
package org.maintenance.form;

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
import org.adempiere.webui.window.Dialog;
import org.compiere.model.MColumn;
import org.compiere.model.MDocType;
import org.compiere.model.MLookup;
import org.compiere.model.MLookupFactory;
import org.compiere.model.MQuery;
import org.compiere.model.PrintInfo; 
import org.maintenance.component.MMPOT;
import org.compiere.print.MPrintFormat;
import org.compiere.print.ReportCtl;
import org.compiere.print.ReportEngine;
import org.compiere.util.CLogger;
import org.compiere.util.DB;
import org.compiere.util.DisplayType;
import org.compiere.util.Env;
import org.compiere.util.KeyNamePair;
import org.compiere.util.Msg;
import org.zkoss.zk.ui.event.Event;
import org.zkoss.zk.ui.event.EventListener;
import org.zkoss.zul.Borderlayout;
import org.zkoss.zul.Center;
import org.zkoss.zul.North;
import org.zkoss.zul.Separator;
import org.zkoss.zul.South;


/**
 * Programacion de Ots 
 *
 * @author  Fabian Aguilar
 * @version $Id: VMPProgrammingOT.java,v 1.2 2010/03/10 00:51:28$
 * 
 * Contributor : Fabian Aguilar - OFBConsulting - programming OT
 */
public class WMPProgrammingOT
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
	public WMPProgrammingOT ()
	{
		
		Env.setContext(Env.getCtx(), m_WindowNo, "IsSOTrx", "Y");   //  defaults to no
		m_C_Currency_ID = Env.getContextAsInt(Env.getCtx(), "$C_Currency_ID");   //  default
		//
		log.info("Currency=" + m_C_Currency_ID);
		try
		{
			
			dynInit();
			zkInit();
			calculate();
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
	private static CLogger log = CLogger.getCLogger(WMPProgrammingOT.class);

	
	private boolean     m_calculating = false;
	private int         m_C_Currency_ID = 0;
	
	//
	private Panel parameterPanel = new Panel();
	private Grid parameterLayout = GridFactory.newGridLayout();
	private Borderlayout mainLayout = new Borderlayout();
	private Panel allocationPanel = new Panel();
	private WListbox otTable =  ListboxFactory.newDataTable();
	private Panel infoPanel = new Panel();
	private int         m_A_Asset_ID = 0;
	private int         m_AD_User_ID = 0;

	
	private Panel otPanel = new Panel();
	private Label otLabel = new Label();
	private Borderlayout otLayout = new Borderlayout();
	private Label otInfo = new Label();
	private Grid allocationLayout = GridFactory.newGridLayout();
	private Button ProcessButton = new Button();
	private Button searchButton = new Button();
	private Button setButton = new Button();
	private Button EnableButton = new Button();
	private Button ChangeButton = new Button();
	private Label assetLabel = new Label();
	private Checkbox selectall = new Checkbox();
	private Label allocCurrencyLabel = new Label();
	private StatusBarPanel statusBar = new StatusBarPanel();
	private Label dateLabel = new Label();
	private WDateEditor dateField = new WDateEditor();
	private WSearchEditor assetSearch = null;
	private WSearchEditor userSearch = null;

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
		otLabel.setText("OT List");
		otPanel.appendChild(otLayout);
		
		otInfo.setText(".");
		
		ProcessButton.setLabel(Msg.getMsg(Env.getCtx(), "Print"));
		ProcessButton.addActionListener(this);
		searchButton.setLabel(Msg.getMsg(Env.getCtx(), "Search"));
		searchButton.addActionListener(this);
		setButton.setLabel(Msg.getMsg(Env.getCtx(),"set User"));
		setButton.addActionListener(this);
		EnableButton.setLabel(Msg.getMsg(Env.getCtx(), "Enable Editing"));
		EnableButton.addActionListener(this);
		ChangeButton.setLabel(Msg.getMsg(Env.getCtx(), "set Date"));
		ChangeButton.addActionListener(this);
		
		
		assetLabel.setText("Usuario");
		selectall.setText(Msg.getMsg(Env.getCtx(), "Seleccionar Todo"));
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
		row.appendChild(assetLabel);
		row.appendChild(userSearch.getComponent());
		row.appendChild(setButton);
		
		South south = new South();
		south.setStyle("border: none");
		mainLayout.appendChild(south);
		south.appendChild(southPanel);
		southPanel.appendChild(allocationPanel);
		allocationPanel.appendChild(allocationLayout);
		allocationLayout.setWidth("400px");
		rows = allocationLayout.newRows();
		row = rows.newRow();
		row.appendChild(selectall);
		row.appendChild(ProcessButton);
	
		otPanel.appendChild(otLayout);
		otPanel.setWidth("100%");
		otPanel.setHeight("100%");
		otLayout.setWidth("100%");
		otLayout.setHeight("100%");
		otLayout.setStyle("border: none");
		
		north = new North();
		north.setStyle("border: none");
		otLayout.appendChild(north);
		north.appendChild(otLabel);
		south = new South();
		south.setStyle("border: none");
		otLayout.appendChild(south);
		south.appendChild(otInfo.rightAlign());
		Center center = new Center();
		otLayout.appendChild(center);
		center.appendChild(otTable);
		otTable.setWidth("99%");
		otTable.setHeight("99%");
		center.setStyle("border: none");
		
		//
		center = new Center();
		mainLayout.appendChild(center);
		center.appendChild(otPanel);
		/*
		infoPanel.setStyle("border: none");
		infoPanel.setWidth("100%");
		infoPanel.setHeight("100%");
		
		north = new North();
		north.setStyle("border: none");
		north.setHeight("49%");
		infoPanel.appendChild(north);
		north.appendChild(otPanel);
		north.setSplittable(true);*/
		
		
		
		
	}   //  jbInit

	

	/**
	 *  Dynamic Init (prepare dynamic fields)
	 *  @throws Exception if Lookups cannot be initialized
	 */
	private void dynInit() throws Exception
	{
		
	
    //	user
		int AD_Column_ID= MColumn.getColumn_ID(MMPOT.Table_Name,"AD_User_ID");
		MLookup lookupUs = MLookupFactory.get (Env.getCtx(), m_WindowNo, 0, AD_Column_ID, DisplayType.Search);
		userSearch = new WSearchEditor("AD_User_ID", true, false, true, lookupUs);
		userSearch.addValueChangeListener(this);
		
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
		 *  Load ot table
		 *      1-TrxDate, 2-DocumentNo, (3-Currency, 4-PayAmt,)
		 *      5-ConvAmt, 6-ConvOpen, 7-Allocated
		 */
		List<List<Object>> data = new ArrayList<List<Object>>();
		StringBuffer sql = new StringBuffer("select o.DATETRX,doc.name,o.DOCUMENTNO,o.AD_USER_ID,o.DESCRIPTION, o.MP_OT_ID, u.name, o.A_Asset_ID, a.name as AssetName"+
				" From MP_OT o " +
				" inner join A_Asset a on (o.A_Asset_ID=a.A_Asset_ID)" +
				" inner join C_DocType doc on (o.C_DocType_ID=doc.C_DocType_ID)" +
				" Left Outer Join AD_User u on(o.AD_User_ID=u.AD_User_ID)" +
				" where o.DOCSTATUS='DR' and not exists " +
				" (select * from MP_OT_TASK t where t.STATUS<>'NS' and t.MP_OT_ID=o.MP_OT_ID)");
		
		log.config("ot=" + sql.toString());
		try
		{
			PreparedStatement pstmt = DB.prepareStatement(sql.toString(), null);
			//pstmt.setInt(1, Instance_ID);
			
			ResultSet rs = pstmt.executeQuery();
			while (rs.next())
			{
				List<Object> line = new ArrayList<Object>();
				line.add(Boolean.FALSE);       //  0-Selection
				line.add(rs.getTimestamp(1));       //  1-fecha programada
				line.add(rs.getString(2)); // 2-tipo OT
				KeyNamePair pp = new KeyNamePair(rs.getInt(6), rs.getString(3));
				line.add(pp); //  3-numero documento
				KeyNamePair pp3 = new KeyNamePair(rs.getInt(8), rs.getString(9));
				line.add(pp3);      //  4-asset
				KeyNamePair pp2 = new KeyNamePair(rs.getInt(4), rs.getString(7));
				line.add(pp2);  //  5-user
				line.add(rs.getString(5)); 				//  6-description
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
		otTable.clear();
		//  Remove previous listeners
		otTable.getModel().removeTableModelListener(this);
		
		//  Header Info
		List<String> columnNames = new ArrayList<String>();
		columnNames.add(Msg.getMsg(Env.getCtx(), "Selected"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "Date Programed"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "Type"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "DocumentNo"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "Asset"));
		columnNames.add(Msg.getMsg(Env.getCtx(), "AD_User_ID"));
		columnNames.add("Descripcion");
		
	//  Set Model
		ListModelTable modelP = new ListModelTable(data);
		modelP.addTableModelListener(this);
		otTable.setData(modelP, columnNames);
		
		//
		int i = 0;
		otTable.setColumnClass(i++, Boolean.class, false);         //  0-Selection
		otTable.setColumnClass(i++, Timestamp.class, false);         //  1-fecha programada
		otTable.setColumnClass(i++, String.class, true);			//2-tipo ot
		otTable.setColumnClass(i++, String.class, true);           //  3-numero documento
		otTable.setColumnClass(i++, String.class, true);       //  4-asset
		otTable.setColumnClass(i++, String.class, true);       //  5-user
		otTable.setColumnClass(i++, String.class, true);      //  6-description

		//  Table UI
		otTable.autoSize();
		
		otTable.setColumnReadOnly(1, false);


		
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
		else if (e.getTarget().equals(ChangeButton)){
			ProcessButton.setEnabled(true);
			//updating rows selected
			ListModelTable ot = otTable.getModel();
			int rows = ot.getRowCount();
			Timestamp DateTrx = (Timestamp)dateField.getValue();
			for (int i = 0; i < rows; i++)
			{
				if (((Boolean)ot.getValueAt(i, 0)).booleanValue())
				{
					KeyNamePair pp = (KeyNamePair)ot.getValueAt(i, 3);//DocumentNo
					int OT_ID=pp.getKey();
					MMPOT currentOT=new MMPOT(Env.getCtx(), OT_ID,null);
					currentOT.setDateTrx(DateTrx);
					currentOT.save();	
					
				}
			}
			loadMPs ();	
		}
		else if (e.getTarget().equals(setButton)){
			ListModelTable ot = otTable.getModel();
			int rows = ot.getRowCount();
			if(m_AD_User_ID!=0){
				for (int i = 0; i < rows; i++)
				{
					if (((Boolean)ot.getValueAt(i, 0)).booleanValue())
					{
						KeyNamePair pp = (KeyNamePair)ot.getValueAt(i, 3);//DocumentNo
						int OT_ID=pp.getKey();
						MMPOT currentOT=new MMPOT(Env.getCtx(), OT_ID,null);
						currentOT.setAD_User_ID(m_AD_User_ID);
						currentOT.save();
						
					}
				}
				loadMPs ();	
			}
		}
		else if (e.getTarget().equals(selectall)){
			ListModelTable ot = otTable.getModel();
			int rows = ot.getRowCount();
			for (int i = 0; i < rows; i++)
			{		
				if(m_A_Asset_ID==0)
					ot.setValueAt(selectall.isSelected(), i, 0);
				else{
					KeyNamePair pp = (KeyNamePair)ot.getValueAt(i, 6);//Asset
					int Asset_ID=pp.getKey();
					if(Asset_ID==m_A_Asset_ID)
						ot.setValueAt(selectall.isSelected(), i, 0);
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
			m_A_Asset_ID = ((Integer)value).intValue();
			
		}else if (name.equals("AD_User_ID")){
			userSearch.setValue(value);
			m_AD_User_ID=((Integer)value).intValue();
		}
		
	}   //  vetoableChange

	
	/**************************************************************************
	 *  Save Data
	 */
	private void saveData()
	{
		
		ListModelTable ot = otTable.getModel();
		int rows = ot.getRowCount();
		//Timestamp DateTrx = (Timestamp)dateField.getValue();
		//Trx trx = Trx.get(Trx.createTrxName("AL"), true);
		for (int i = 0; i < rows; i++)
		{
			if (((Boolean)ot.getValueAt(i, 0)).booleanValue())
			{
				KeyNamePair pp = (KeyNamePair)ot.getValueAt(i, 3);//OT
				int OT_ID=pp.getKey();
				try{
					MMPOT currentOT=new MMPOT(Env.getCtx(), OT_ID,null);
					MDocType doc=new MDocType(Env.getCtx(), currentOT.getC_DocType_ID(),null);
					int AD_PrintFormat_ID = doc.getAD_PrintFormat_ID();
					int C_BPartner_ID = 0;
					String DocumentNo = currentOT.getDocumentNo();
					int copies = 1;
					MPrintFormat format = MPrintFormat.get (Env.getCtx(), AD_PrintFormat_ID, false);
					MQuery query = new MQuery("MP_OT");
					query.addRestriction("MP_OT_ID", MQuery.EQUAL, Integer.valueOf(OT_ID));
					PrintInfo info = new PrintInfo(
							DocumentNo,
							MMPOT.Table_ID,
							OT_ID,
							C_BPartner_ID);
						info.setCopies(copies);
						info.setDocumentCopy(false);		//	true prints "Copy" on second
						info.setPrinterName(format.getPrinterName());
					ReportEngine re = new ReportEngine(Env.getCtx(), format, query, info, null);
					ReportCtl.preview(re);
					 
				}
				catch (Exception e)
				{
					Dialog.warn(form.getWindowNo(),"Print format is not properly defined");
				}
			}
		}
		loadMPs ();
	}   //  saveData
	


	/**
	 * Called by org.adempiere.webui.panel.ADForm.openForm(int)
	 * @return
	 */
	public ADForm getForm()
	{
		return form;
	}
	

}   //  VAllocation
