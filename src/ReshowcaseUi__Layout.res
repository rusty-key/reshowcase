module Color = {
  let white = "#fff"
  let lightGray = "#f5f6f6"
  let midGray = "#e0e2e4"
  let darkGray = "#42484d"
  let black40a = "rgba(0, 0, 0, 0.4)"
  let blue = "#0091ff"
  let orange = "#ffae4b"
  let transparent = "transparent"
}

module Gap = {
  let xxs = "3px"
  let xs = "7px"
  let md = "10px"

  type t = Xxs | Xs | Md

  let getGap = (gap: t) =>
    switch gap {
    | Xxs => xxs
    | Xs => xs
    | Md => md
    }
}

module Border = {
  let default = `1px solid ${Color.midGray}`
}

module PaddedBox = {
  type padding = Around | LeftRight | TopLeftRight

  type border = None | Bottom

  module Styles = {
    let around = gapValue => ReactDOM.Style.make(~padding=gapValue, ())
    let leftRight = gapValue => ReactDOM.Style.make(~padding=`0 ${gapValue}`, ())
    let topLeftRight = gapValue => ReactDOM.Style.make(~padding=`${gapValue} ${gapValue} 0`, ())

    let getPadding = (padding: padding, gap: Gap.t) => {
      let gapValue = Gap.getGap(gap)
      switch padding {
      | Around => around(gapValue)
      | LeftRight => leftRight(gapValue)
      | TopLeftRight => topLeftRight(gapValue)
      }
    }

    let getBorder = (border: border) => {
      switch border {
      | None => ReactDOM.Style.make()
      | Bottom => ReactDOM.Style.make(~borderBottom=Border.default, ())
      }
    }

    let make = (~padding, ~gap, ~border) => {
      let paddingStyles = getPadding(padding, gap)
      let borderStyles = getBorder(border)
      ReactDOM.Style.combine(paddingStyles, borderStyles)
    }
  }

  @react.component
  let make = (~gap: Gap.t=Xs, ~padding: padding=Around, ~border: border=None, ~id=?, ~children) => {
    <div name="PaddedBox" ?id style={Styles.make(~padding, ~border, ~gap)}> children </div>
  }
}

module Stack = {
  module Styles = {
    let stack = ReactDOM.Style.make(~display="grid", ~gridGap=Gap.xs, ())
  }

  @react.component
  let make = (~children) => {
    <div name="Stack" style={Styles.stack}> children </div>
  }
}

module Sidebar = {
  module Styles = {
    let width = "230px"

    let sidebar = (~fullHeight) =>
      ReactDOM.Style.make(
        ~minWidth=width,
        ~width,
        ~height={fullHeight ? "100vh" : "auto"},
        ~overflowY="auto",
        ~backgroundColor=Color.lightGray,
        (),
      )->ReactDOM.Style.unsafeAddProp("WebkitOverflowScrolling", "touch")
  }

  @react.component
  let make = (~innerContainerId=?, ~fullHeight=false, ~children=React.null) => {
    <div name="Sidebar" id=?innerContainerId style={Styles.sidebar(~fullHeight)}> children </div>
  }
}

module Icon = {
  let desktop =
    <svg width="32" height="32">
      <g transform="translate(5 8)" fill="none" fillRule="evenodd">
        <rect stroke="currentColor" x="2" width="18" height="13" rx="1" />
        <rect fill="currentColor" y="13" width="22" height="2" rx="1" />
      </g>
    </svg>

  let mobile =
    <svg width="32" height="32">
      <g transform="translate(11 7)" fill="none" fillRule="evenodd">
        <rect stroke="currentColor" width="10" height="18" rx="2" />
        <path d="M2 0h6v1a1 1 0 01-1 1H3a1 1 0 01-1-1V0z" fill="currentColor" />
      </g>
    </svg>

  let sidebar =
    <svg width="32" height="32">
      <g
        stroke="currentColor"
        strokeWidth="1.5"
        fill="none"
        fillRule="evenodd"
        strokeLinecap="round"
        strokeLinejoin="round">
        <path d="M25.438 17H12.526M19 10.287L12.287 17 19 23.713M8.699 7.513v17.2" />
      </g>
    </svg>

  let close =
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="18"
      height="18"
      viewBox="0 0 18 18"
      style={ReactDOM.Style.make(~display="block", ())}>
      <path
        fill="gray"
        d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"
      />
    </svg>
}

module HighlightSubstring = {
  @react.component
  let make = (~text, ~substring) =>
    switch substring {
    | "" => text->React.string
    | _ => {
        let indexFrom = Js.String2.indexOf(
          Js.String2.toLowerCase(text),
          Js.String2.toLowerCase(substring),
        )
        switch indexFrom {
        | -1 => text->React.string
        | _ =>
          let indexTo = indexFrom + Js.String2.length(substring)
          let leftPart = Js.String2.slice(text, ~from=0, ~to_=indexFrom)
          let markedPart = Js.String2.slice(text, ~from=indexFrom, ~to_=indexTo)
          let rightPart = Js.String2.slice(text, ~from=indexTo, ~to_=Js.String2.length(text))
          <>
            {leftPart->React.string}
            <mark style={ReactDOM.Style.make(~backgroundColor=Color.orange, ())}>
              {markedPart->React.string}
            </mark>
            {rightPart->React.string}
          </>
        }
      }
    }
}
