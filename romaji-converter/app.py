import argparse
import sys
import re
import cutlet

DA_TTE_SEARCH_REGEX = re.compile(r"\b[dD]a tte\b")

katsu = cutlet.Cutlet()
# I mostly translate lyrics, they never use the formal "watakushi"
katsu.add_exception("私", "watashi")

def romaji_and_fix_known_errors(japanese_text: str):
    romaji = katsu.romaji(japanese_text)
    # It likes to split "だって" into "da tte" instead of "datte"
    romaji = DA_TTE_SEARCH_REGEX.sub("datte", romaji)
    return romaji


def run_cli(input_file, output_file):
    if input_file:
        with open(input_file, "r", encoding="utf-8") as f:
            text = f.read()
    else:
        text = sys.stdin.read()

    romaji = romaji_and_fix_known_errors(text)

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
        return {"romaji": romaji_and_fix_known_errors(payload.text)}

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
