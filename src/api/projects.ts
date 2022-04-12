import request from "./request";

export function getProjectList() {
  return request.get("config.json");
}
