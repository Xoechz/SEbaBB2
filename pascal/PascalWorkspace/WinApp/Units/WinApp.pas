(* ==================== *)
(* Unit with message loop implementation for a basic single-window Windows application. *)
(* (C) Gabriel Horn-Voellenkle 02.06.2019 *)
(* ==================== *)
(* RESOURCES *)
(* Windows Programming: https://msdn.microsoft.com/en-us/library/windows/desktop/ff381409(v=vs.85).aspx *)
(* GDI: https://msdn.microsoft.com/en-us/library/windows/desktop/dd145203(v=vs.85).aspx *)
(* ==================== *)
UNIT WinApp;

INTERFACE

USES Windows;

VAR
	OnPaint: PROCEDURE(wnd: HWnd; dc: HDC);
	OnMouseDown: PROCEDURE(wnd: HWnd; x, y: INTEGER);

PROCEDURE Run;

IMPLEMENTATION

CONST
	WindowClassName = 'WinApp';
	WindowName = 'WinApp';

FUNCTION WindowProc(wnd: HWnd; msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall; EXPORT;
VAR
	ps: TPaintStruct;
	dc: HDC;
BEGIN
	CASE msg OF
		WM_DESTROY:
			(* post quit message when main window is closed *)
			PostQuitMessage(0);
		WM_PAINT:
			(* raise paint event if event handler is attached *)
			IF @OnPaint <> NIL THEN BEGIN
				dc := BeginPaint(wnd, ps);
				OnPaint(wnd, dc);
				EndPaint(wnd, ps);
			END;
		WM_LBUTTONDOWN:
			(* raise mouse down event if event handler is attached *)
			IF @OnMouseDown <> NIL THEN
				OnMouseDown(wnd, Get_X_LParam(lParam), Get_Y_LParam(lParam));
		(* TODO: keyboard event *)			
		ELSE
			(* use default message handling *)
			WindowProc := DefWindowProc(wnd, msg, wParam, lParam);
	END;
END;

PROCEDURE Run;
VAR
	wndClass: TWndClass;	
	wnd: HWnd;
	msg: TMsg;
BEGIN
	(* register window class for main window (if this is the first application instance) *)
	IF hPrevInst = 0 THEN BEGIN
		wndClass.lpfnWndProc   := WndProc(@WindowProc);
		wndClass.cbClsExtra    := 0;
		wndClass.cbWndExtra    := 0;
		wndClass.lpszMenuName  := NIL;
		wndClass.lpszClassName := WindowClassName;
		wndClass.hInstance     := 0;
		wndClass.style         := CS_VREDRAW OR CS_HREDRAW;
		wndClass.hIcon         := 0;
		wndClass.hCursor       := LoadCursor(0, IDC_ARROW);
		wndClass.hbrBackground := COLOR_WINDOW;
		IF RegisterClass(wndClass) = 0 THEN BEGIN
			MessageBox(0, 'RegisterClass failed.', NIL, MB_OK);
			Halt;
		END;
	END;

	(* create and show main window *)
	wnd := CreateWindow(WindowClassName,
		WindowName, (* window text *)
		WS_OVERLAPPEDWINDOW, (* window style *)
		CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, (* default size and position *)
		0, (* no parent window *)
		0, (* no menu *)
		hInstance, (* instance handle *)
		NIL (* no additional application data *)
	);
	IF wnd = 0 THEN BEGIN
		MessageBox(0, 'CreateWindow failed.', NIL, MB_OK);
		Halt;
	END;
	ShowWindow(wnd, cmdShow);

	(* start message loop *)
	WHILE GetMessage(msg, 0, 0, 0) DO BEGIN
		TranslateMessage(msg); (* translate keyboard input messages *)
		DispatchMessage(msg); (* dispatch message to according window *)
	END;
END;

BEGIN
	OnPaint := NIL;
	OnMouseDown := NIL;
END.