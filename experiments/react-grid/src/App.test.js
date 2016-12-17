import React from 'react'
import ReactDOM from 'react-dom'
import App from './App';
import { shallow, mount, render } from 'enzyme'

// construct a participant
const newP = (name, isFeatured=false) => ({
  identity:  name,
  media:     { url: `/${name}.jpg` },
  connected: true,
  featured:  isFeatured,
})

const willNotBeCalled = () => { throw(arguments) }

const appFor = (participants, setFeatured=willNotBeCalled) => {
  const state = { type: "mediaList", list: participants }
  return mount(<App state={state} setFeatured={setFeatured}/>)
}

it('renders each participant\'s media in the list', () => {
  const participants = [newP('josh-ren'), newP('josh-pumpkin')]
  const srcs = appFor(participants).find('.List .Media').map(i => i.props().src)
  expect(srcs).toEqual(["/josh-ren.jpg", "/josh-pumpkin.jpg"])
})


const assertFeatured = (participants, expectedUrl) => {
  const actualUrl = appFor(participants).find('.Featured .Media').props().src
  expect(actualUrl).toEqual(expectedUrl)
}

it('renders the focused media in its own easily consumable view', () => {
  assertFeatured(
    [newP('josh-ren', true), newP('josh-pumpkin')],
    "/josh-ren.jpg"
  )
  assertFeatured(
    [newP('josh-ren'), newP('josh-pumpkin', true)],
    "/josh-pumpkin.jpg"
  )
})

it('renders the first media as featured when none are explicitly featured', () => {
  assertFeatured(
    [newP('josh-ren'), newP('josh-pumpkin')],
    "/josh-ren.jpg"
  )
})


it('swaps the focused media when clicked', () => {
  const participants = [newP('josh-ren'), newP('josh-pumpkin')]

  // if there's a lot of this sort of thing, there's a spy lib, sinon, for this purpose
  let focused = null
  const app = appFor(participants, (media) => focused = media)

  // why can't I do:
  // const [first, last] = app.find('.List .Media')
  const media = app.find('.List .Media')
  const first = media.first()
  const last  = media.last ()

  expect(focused).toEqual(null)
  first.simulate('click')
  expect(focused.identity).toEqual('josh-ren')
  last.simulate('click')
  expect(focused.identity).toEqual('josh-pumpkin')
})
