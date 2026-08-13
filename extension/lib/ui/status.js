import { a as require_jsx_runtime, c as __toESM, i as TabItem, o as require_client, r as Button, s as require_react, t as AuthTokenSection } from "./authToken.js";
//#region src/ui/status.tsx
var import_react = /* @__PURE__ */ __toESM(require_react());
var import_client = require_client();
var import_jsx_runtime = require_jsx_runtime();
var StatusApp = () => {
	const [connectedTabs, setConnectedTabs] = (0, import_react.useState)([]);
	const [clientName, setClientName] = (0, import_react.useState)(void 0);
	(0, import_react.useEffect)(() => {
		loadStatus();
	}, []);
	const loadStatus = async () => {
		const { connectedTabIds, clientName } = await chrome.runtime.sendMessage({ type: "getConnectionStatus" });
		setConnectedTabs(await Promise.all((connectedTabIds ?? []).map((tabId) => chrome.tabs.get(tabId))));
		setClientName(clientName);
	};
	const openTab = async (tabId) => {
		await chrome.tabs.update(tabId, { active: true });
		window.close();
	};
	const disconnect = async () => {
		await chrome.runtime.sendMessage({ type: "disconnect" });
		window.close();
	};
	return /* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", {
		className: "app-container",
		children: /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
			className: "content-wrapper",
			children: [connectedTabs.length > 0 ? /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", { children: [
				/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
					className: "connection-header",
					children: [/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
						className: "client-info",
						children: ["Connected to ", /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("strong", { children: [
							"\"",
							clientName || "unknown",
							"\""
						] })]
					}), /* @__PURE__ */ (0, import_jsx_runtime.jsx)(Button, {
						variant: "primary",
						onClick: disconnect,
						children: "Disconnect"
					})]
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", {
					className: "tab-section-title",
					children: connectedTabs.length === 1 ? "Accessible page:" : "Accessible pages:"
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", { children: connectedTabs.map((tab) => /* @__PURE__ */ (0, import_jsx_runtime.jsx)(TabItem, {
					tab,
					onClick: () => openTab(tab.id)
				}, tab.id)) })
			] }) : /* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", {
				className: "status-banner",
				children: "No clients are currently connected. You can connect from the Playwright CLI or MCP server by passing the --extension flag."
			}), /* @__PURE__ */ (0, import_jsx_runtime.jsx)(AuthTokenSection, {})]
		})
	});
};
var container = document.getElementById("root");
if (container) (0, import_client.createRoot)(container).render(/* @__PURE__ */ (0, import_jsx_runtime.jsx)(StatusApp, {}));
//#endregion
