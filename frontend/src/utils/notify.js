import { Notify } from 'quasar'

export function notify(type, message) {
  Notify.create({
    type,
    message,
    position: 'top',
    timeout: 2500,
  })
}

export const notifySuccess = (msg) => notify('positive', msg)
export const notifyError = (msg) => notify('negative', msg)
export const notifyInfo = (msg) => notify('info', msg)
export const notifyWarning = (msg) => notify('warning', msg)
