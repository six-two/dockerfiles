import argparse
import sys
import cutlet

katsu = cutlet.Cutlet()


def run_cli(input_file, output_file):
    if input_file:
        with open(input_file, "r", encoding="utf-8") as f:
            text = f.read()
    else:
        text = sys.stdin.read()

    romaji = katsu.romaji(text)

    if output_file:
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(romaji + "\n")
    else:
        print(romaji)


def run_server(port):
    from fastapi import FastAPI
    from pydantic import BaseModel
    import uvicorn

    app = FastAPI()

    class RomanizeRequest(BaseModel):
        text: str

    @app.post("/romanize")
    def romanize(payload: RomanizeRequest):
        return {"romaji": katsu.romaji(payload.text)}

    uvicorn.run(app, host="0.0.0.0", port=port)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=None, help="Run as a web server on this port")
    parser.add_argument("-i", "--input", default=None, help="Input file (defaults to stdin)")
    parser.add_argument("-o", "--output", default=None, help="Output file (defaults to stdout)")
    args = parser.parse_args()

    if args.port:
        run_server(args.port)
    else:
        run_cli(args.input, args.output)


if __name__ == "__main__":
    main()
